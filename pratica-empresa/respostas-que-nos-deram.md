# Respostas que o grupo 4 nos deu

1 - Sistemas de ERP para lojas e supermercados, consultoria e implantação e suporte técnico.

2 - Lojistas e supermercados

3 - Que forneçam uma segurança ou noção dela em relação aos nossos produtos e infraesfrutura, para que os clientes se sintam também seguros.

4 - 40

5 - O que seria um "terceirizado"? Utilizamos serviços de hospedagem para o ambiente de desenvolvimento e também para as aplicações.
Contratamos também alguns serviços de manutenção da empresa

6 - Temos 50 computadores de desktop, 10 laptops, 5 clusters de servidores da aws 2 servidores locais para backup.

7 - Híbrido

8 - Sim, sofremos um ataque de ransomware. Não perdemos códigos ou qualquer progresso de desenvolvimento por conta de backups,
mas passamos 15 dias fazendo manutenção em serviços de infraesfrutura.

9 - Sim.

10 - Não.

11 - Sim.

12 - Sim. Todos os funcionários conseguem passar pelas portas da empresa com seus crachás RFID.

13 - Sim, no exterior e interior.

14 - Sim, são mantidos localmente.

15 - Não.

16 - Os ambientes windows atualizam automaticamente. 

17 - Sim.

18 - Provavelmente sim.

# Follow-up

## Sobre a resposta 1

- Quais linguagens de programação são utilizadas?
- Quais bancos de dados são utilizados?
- Como funciona o sistema de autenticação do sistema?
- Onde o código fonte é hospedado?
- O deploy das aplicações é feito automaticamente?
- É utilizado alguma solução de análise de código fonte (como o SonarQube)?
- O sistema possui testes de integração?
- O sistema possui testes de estresse?
- A empresa possui uma equipe focada em qualidade de software?
- O sistema possui integração com serviços de terceiros (se sim, quais)?
- Qual é a periodicidade do backup?

## Sobre a resposta 5

Funcionários tercerizados são funcionários de outras empresas que trabalham alocados dentro da tua empresa e que, por consequência, precisam de acessos similares aos dos teus funcionários (tanto acessos físicos quanto eletrônicos).

## Sobre a resposta 8

- Vocês conseguiram identificar como o ransomware entrou na rede?
- Vocês sabem qual o nome do ransomware especificamente?
- Quem ficou responsável por investigar o ataque e restaurar o backup? 

## Sobre a resposta 12

- O acesso dos funcionários é logado em algum lugar?
- O horário de entrada e saída é controlado?
- Como é o gerenciamento de crachás de ex-funcionários ou crachás extraviados?

## Sobre a resposta 14

- Os logs são do sistema operacional, das aplicações de vocês, do firewall, etc?
- Estes logs são armazenados nos dois servidores locais?
- Por quanto tempo os logs são mantidos?
- Quais soluções de monitoramento ativo são utilizadas?

## Sobre a resposta 18

- Qual é a versão do sistema operacional usado nos servidores de backup?
- Existe alguma política de atualização dos softwares usados nestes servidores (banco de dados, antivirus, cliente VPN, etc)?
