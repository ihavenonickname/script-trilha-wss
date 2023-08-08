#!/bin/bash



################################################################################
#                     CONSIDERAÇÕES GERAIS SOBRE O SCRIPT                      #
################################################################################

# Sobre bash vs sh
#
# Este script utiliza o bash para ser executado. O bash é um superset do sh,
# similar ao C++ que é um superset de C. Há várias funcionalidades presentes no
# bash que não existem no sh clássico, tais como:
#
# - Arrays
# - Expressões booleanas complexas
# - Funções
#
#
# Sobre o uso de subshell
#
# No bash, os parênteses são usados para criar um subshell, que é uma instância
# separada do shell rodando em um processo-filho a partir do shell atual. Neste
# script vários subshells são criados, e isso é feito por alguns motivos:
#
# 1. Concatenar o output de uma lista de comandos. Isto é necessário para gerar
# uma pipeline de processamento sem a necessidade de armazenar o output de
# alguns comandos em arquivos temporários, fazendo com que o output de N
# comandos sejam tratados como um só, similar a um `union all` do SQL.
# 2. Agrupar comandos relacionados. Apesar de não ser necessário para a
# execução do script, este estilo foi adotado para facilitar a leitura e
# manutenção do script, pois os comandos são agrupados em blocos lógicos que
# cumprem uma tarefa específica.
# 3. Quebrar o script em múltiplas linhas com comentários entre os comandos.
# Também seria possível utilizar a contrabarra para quebrar o script em
# múltiplas linhas, mas a sintaxe do bash não aceita comentários entre
# contrabarras.
#
#
# Sobre o descarte do stderr
#
# A sintaxe `2> /dev/null` é utilizada para ignorar o stderr dos comandos.
# Por convenção, o stderr geralmente é utilizado para printar textos em
# linguagem natural para serem lidos por seres humanos.
# Similarmente, o stdout é utilizado para printar textos estruturados para
# serem processados pelo computador.
# Aqui só interessa o texto estruturado que é processado pela pipeline.



################################################################################
#                             PROCESSAR ARGUMENTOS                             #
################################################################################

# A data e hora UTC em formato compatível com ISO 8601 é utilizada no nome dos
# arquivos que contêm o output intermediário de cada passo.
start_date=$(date -u +"%Y-%m-%dT%H-%M-%SZ")

# Domínio base que é informado através do argumento -d.
root_domain=""

# Itera por todos os argumentos passados pro script.
while getopts "d:" opt;
do
    case $opt in
        d) # O domínio base foi informado
            root_domain="$OPTARG"
            ;;
        :) # Um argumento não teve nenhum valor informado
            exit 1
            ;;
        \?) # Argumento não reconhecido
            exit 1
            ;;
    esac
done

if [ -z $root_domain ];
then
    echo "Root domain cannot be empty" >&2;
    exit 1;
fi

function get_output_filename
{
    echo "script-$start_date-step-$1.txt"
}

echo "Root domain: $root_domain"



################################################################################
#                      PASSO 1 - ENUMERAR OS SUBDOMÍNIOS                       #
################################################################################

echo "Step 1 - Enumerate subdomains"

step_1_start_ts=$(date +%s)

# Neste passo várias fontes públicas são consultadas para encontrar os
# subdomínios abaixo do domínio base recebido por parâmetro. Nenhuma
# interação com o alvo é feita neste passo.

# Como duas ferramentas de enumeração são utilizadas neste passo, é preciso
# criar um  subshell para concatenar o output de ambas as ferramentas,
# permitindo que os demais comandos consigam processar cada subdomínio em
# uma pipeline única.
(
    # Flags utilizadas no amass
    # -passive: Apenas consultar as fontes públicas sem interagir com o alvo.
    # -d <string>: Domínio base a ser enumerado.
    amass enum -passive -d $root_domain 2> /dev/null;
    # Flags utilizadas no findomain
    # -q: Não printar nada no stderr.
    # -t <string>: Domínio base a ser enumerado.
    findomain -q -t $root_domain
    # Flags utilizadas no subfinder
    # -silent: Não printar nada no stderr.
    # -d <string>: Domínio base a ser enumerado.
    #
    # O subfinder não precisa de uma flag -passive como o amass porque a
    # enumeração do subfinder sempre é passiva.
    subfinder -silent -d $root_domain
) | (
    # Como as ferramentas de enumeração consultam várias fontes em comum, a
    # vasta maioria dos subdomínios encontrados são repetidos. Por conta
    # disso é necessário remover os duplicados.
    #
    # O comando sort ordena as linhas recebidas no stdin de forma
    # lexicográfica e ascendente.
    sort
) | (
    # O comando uniq remove linhas duplicadas que estejam em posições
    # adjacentes. É por este motivo que o comando sort é chamado antes do
    # uniq.
    uniq
) | (
    # Ao fim deste passo, o formato do stdout é:
    # mail.example.com
    # qa.example.com
    # www.example.com
    cat > $(get_output_filename 1)
)

step_1_end_ts=$(date +%s)
step_1_elapsed_seconds=$((step_1_end_ts - step_1_start_ts))

echo "Step 1 - Finished in $step_1_elapsed_seconds seconds"



################################################################################
#                         PASSO 2 - OBTER AS URLS ATIVAS                       #
################################################################################

echo "Step 2 - Get the active URLs"

step_2_start_ts=$(date +%s)

# Faz uma requisição HTTP para cada subdomínio a fim de descobrir o
# protocolo utilizado (http ou https) e o status code. É importante notar
# que este comando gera ruído no alvo. Até aqui a pipeline fez apenas
# reconhecimento passivo, a partir deste ponto se torna reconhecimento
# ativo.

cat $(get_output_filename 1) | (
    # Flags utilizadas no httpx-toolkit
    # -sc: Printa o status code da requisição.
    #
    # Este comando ignora automaticamente domínios não-responsivos.
    httpx-toolkit -sc 2> /dev/null
) | (
    # Flags utilizadas no grep
    # -v: Inverte a captura. Ou seja, printa somente as linhas que _não_
    # contêm a regex.
    grep -v "\[404]"
) | (
    # Flags utilizadas no cut
    # -d <string>: Informa o delimitador para fatiar a string.
    # -f <int>: Informa o índice (iniciando em 1) da fatia selecionada.
    cut -d ' ' -f 1
) | (
    # Ao fim deste passo, o formato do stdout é:
    # https://mail.example.com
    # https://www.example.com
    cat > $(get_output_filename 2)
)

step_2_end_ts=$(date +%s)
step_2_elapsed_seconds=$((step_2_end_ts - step_2_start_ts))

echo "Step 2 - Finished in $step_2_elapsed_seconds seconds"



################################################################################
#                       PASSO 3 - ENUMERAR OS DIRETÓRIOS                       #
################################################################################

echo "Step 3 - Enumerate directories"

step_3_start_ts=$(date +%s)

# Aplica um brute-force em cada URL a fim de encontrar páginas acessíveis e
# possivelmente vulneráveis.

cat $(get_output_filename 2) | (
    # O comando dirb testa uma lista de diretórios em uma dada URL. Caso
    # nenhuma lista de diretórios seja informada (como é o caso aqui) ele
    # utiliza a lista padrão que possui vários diretórios comuns em
    # servidores web.
    #
    # Este comando espera receber a URL no primeiro parâmetro posicional,
    # ou seja, não é possível encadear o dirb usando pipes. Por este motivo,
    # o comando xargs atua como um "wraper" que redireciona cada linha do
    # stdin para o primeiro parâmetro do dirb.
    #
    # Flags utilizadas no xargs
    # -I <string>: Informa o placeholder que será substituido pela linha
    # vinda do stdin.
    #
    # Flags utilizadas no dirb
    # -S: Modo silencioso. Não mexe na posição do cursor.
    xargs -I {} dirb {} -S
) | (
    # Como o output do dirb mistura texto em inglês, marcadores e outras
    # coisas, é necessário aplicar o grep e o cut para extrair as URLs que
    # realmente interessam.
    #
    # Flags utilizadas no grep
    # -E: Iutilizar o motor de regex estendido. Necessário por conta da
    # âncora de início da string.
    grep -E '^==> DIRECTORY:'
) | (
    # Flags utilizadas no cut
    # -d <string>: Informa o delimitador para fatiar a string.
    # -f <int>: Informa o índice (iniciando em 1) da fatia selecionada.
    cut -d ' ' -f 3
) | (
    # Ao fim deste passo, o formato do stdout é:
    # https://mail.example.com/admin
    # https://mail.example.com/files
    # https://www.example.com/cpanel
    # https://www.example.com/wwwroot/static
    cat > $(get_output_filename 3)
)

step_3_end_ts=$(date +%s)
step_3_elapsed_seconds=$((step_3_end_ts - step_3_start_ts))

echo "Step 3 - Finished in $step_3_elapsed_seconds seconds"
