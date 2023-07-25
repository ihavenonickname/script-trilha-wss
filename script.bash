#!/bin/bash

# Considerações gerais sobre o script:
#
#
# Vários subshells são utilizados para duas finalidades:
#
# 1. Concatenar o output de uma lista de comandos. Isto é necessário para gerar
# uma pipeline de processamento sem a necessidade de armazenar o output de
# alguns comandos em arquivos temporários
# 2. Agrupar comandos relacionados. Isto é importante para facilitar a leitura
# do script, pois o leitor consegue identificar os comandos que fazem parte de
# um mesmo passo (um "agrupamento lógico" por assim dizer).
#
#
# A sintaxe `2> /dev/null` é utilizada para ignorar o stderr dos comandos.
# Por convenção, o stderr geralmente é utilizado para printar textos em
# linguagem natural para seres lidos por seres humanos.
# Similarmente, o stdout é utilizado para printar textos estruturados para
# serem processado pelo computador.
# Aqui só interessa o texto estruturado que é processado pela pipeline.

# Este script deve receber no primeiro parâmetro o domínio base que será usado
# na pipeline de recon.
root_domain="$1"

(
    # Passo 1 - Enumerar os subdomínios.
    # Neste passo as ferramentas de enumeração de subdomínios são chamadas e o
    # output é concatenado, permitindo que os demais passos consigam processar
    # cada subdomínio em uma pipeline única.
    # O output de ambos os comandos é um domínio completo (subdomínio + domínio
    # base) por linha. Exemplo:
    # www.example.com
    # mail.example.com
    # qa.example.com

    # Flags utilizadas no amass
    # -passive: Apenas consultar as fontes públicas sem interagir com o alvo.
    # -d <string>: Domínio base a ser enumerado.
    amass enum -passive -d $root_domain 2> /dev/null;

    # Flags utilizadas no subfinder
    # -silent: Não printar nada no stderr.
    # -d <string>: Domínio base a ser enumerado.
    #
    # O subfinder não precisa de uma flag -passive como o amass porque a
    # enumeração do subfinder sempre é passive.
    subfinder -silent -d $root_domain
) | (

    # Passo 2 - Remover subdomínios duplicados.
    # Como as ferramentas de enumeração consultam várias fontes em comum, a
    # vasta maioria dos subdomínios encontrados são repetidos. Por conta disso
    # é necessário remover os duplicados.

    # O comando sort ordena as linhas recebidas no stdin de forma
    # lexicográfica e ascendente.
    #
    # O comando uniq remove linhas duplicadas que estejam em posições
    # adjacentes. É por este motivo que o comando sort é usado antes de
    # chamar o uniq.
    sort | uniq
) | (

    # Passo 3 - Obter a URL completa.
    # Este comando gera ruído no alvo. Até aqui a pipeline fez apenas
    # reconhecimento passivo, a partir deste ponto se torna reconhecimento
    # ativo.

    # Flags utilizadas no httpx-toolkit
    # -sc: Printa o status code da requisição.
    #
    # O formato do output é:
    # https://www.example.com [200]
    #
    # Este comando ignora automaticamente domínios não-responsivos.
    httpx-toolkit -sc 2> /dev/null
) | (

    # Passo 4 - Ignorar as URLs que responderam Not Found.

    # Aqui o grep ignora as linhas que contêm o texto "[404]", depois o cut
    # pega somente o texto que está antes do primeiro espaço, que no caso é a
    # URL retornada pelo httpx.

    # Flags utilizadas no grep
    # -v: Inverte a captura. Ou seja, printa somente as linhas que _não_
    # contêm a regex.
    #
    # Flags utilizadas no cut
    # -d <string>: Informa o delimitador para fatiar a string.
    # -f <int>: Informa o índice (começando em 1) da fatia selecionada.
    grep -v "\[404]" | cut -d ' ' -f 1
) | (

    # Passo 5 - Enumerar diretórios.
    # Neste passo uma lista de diretórios comuns são testados em cada uma das
    # URLs a fim de encontrar páginas acessíveis, possivelmente vulneráveis.

    # O comando dirb só consegue receber a URL no primeiro parâmetro
    # posicional, ou seja, não é possível encadear o dirb usando pipes.
    # Por este motivo, o comando xargs atua como um "wraper" que redireciona
    # cada linha do stdin para o primeiro parâmetro do dirb.

    # Flags utilizadas no xargs
    # -I <string>: Informe o placeholder que será substituido pela linha vinda
    # do stdin.
    #
    # Flags utilizadas no dirb
    # -S: Modo silencioso. Não mexe na posição do cursor.
    #
    # Como o output do dirb mistura texto em inglês, marcadores e outras
    # coisas, é necessário aplicar o grep e o cut para extrair as URLs que
    # realmente interessam.
    #
    # As flags do cut já foram explicadas anteriormente. No caso do grep, a
    # flag `-E` informa que o grep deve utilizar o motor de regex estendido.
    # Isso é necessário por causa do caractere especial `^` que é a âncora de
    # início da string.
    #
    # Ao fim deste passo, o formato do output é:
    # https://www.example.com/cpanel
    # https://www.example.com/wwwroot/static
    # https://www.example.com/admin
    xargs -I {} dirb {} -S | grep -E '^==> DIRECTORY:' | cut -d ' ' -f 3
)
