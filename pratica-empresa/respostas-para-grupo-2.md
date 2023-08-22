
# Nossas respostas para o grupo 2

## 1-Quais tecnologias são usadas?

- FortGate cliente de VPN
- dotnet core 2
- PHP 8.1
- SQL Server 2008
- Windows 10
- Windows Server 2012
- RDP nativo do Windows
- Bitwarden 
- 2FA com MS Authenticator




## 2-Tem um gerenciamento de acesso físico na empresa? 

Sim.

Se sim, qual a forma de controle de acesso aos ambientes?

A empresa terceiriza serviços de limpeza e algumas demandas de desenvolvimento de software.

Os terceirizados da limpeza possuem acesso físico à sede, inclusive em horários em que não tem nenhum funcionário no prédio.

Os terceirizados de desenvolvimento só trabalham remotamente.




## 3-Existe gerenciamento de acesso externo ao sistema e arquivos?

Para logar nas máquinas de trabalho é necessário autenticação em 2 fatores com MS Auth.

Para acessar pastas compartilhadas é preciso estar na VPN.





## 4-Existe gerenciamento de acesso na rede, VLAN?

Acessamos a rede interna com o cliente FortGate e cada usuário tem sua permissão gerida no AD.





## 5-Tem um gerenciamento de portas?

Usamos o firewall da CloudFlare.




## 6-Existe algum plano de resposta ao incidente?

Que incidente?




## 7-A empresa possui plano de desastre?

Sim. Existe redundância de dados em 3 continentes diferentes.





## 8-Tem plano de continuidade de negócio?

Não.




## 9-Os colaboradores utilizam notebooks corporativos ou são equipamentos próprios?

Utilizam notebooks corporativos.





## 10-A empresa possui filiais?

Não.




## 11-Quantas pessoas tem?

100 funcionários diretos e por volta de 10 terceirizados.




## 12-Tem rotinas de atualização de ambientes?

A equipe de infra gerencia a atualização automática do Windows nas máquinas dos funcionários.




## 13-Tem data center, se sim, local ou na nuvem?

Sim, possui somente infra própria.





## 14-A empresa está adequada a LGPD?

Sim.

## PARTE 2

## 1 - A empresa possui alguma forma de gestão de ativos? Se sim, como ela é feita?

Sim, controle sobre quais funcionários estão com cada máquina. Também tem controle de acesso aos servidores, com log de acesso

## 2 - As documentações são compartilhadas entre os setores ou filiais?

Não tem filial, mas é compatilhado entre setores

## 3 - Qual é o serviço que mais gera retorno? ou quais?

API para integração de pagamentos

## 4 - Vocês já consideraram fazer uma modelagem de ameaças? se não, por quê?

Não, por isso queremos contratar o serviço

## 5 - Como é realizado o gerenciamento de acessos ao banco de dados para terceiros?

Os terceirizados não acessam o banco de dados

## 6 - Há uma política de segurança definida para as filiais? Ou cabe a elas definirem suas próprias?

Não tem filial

## 7- Em relação aos ativos hospedados na nuvem, como é garantido a visibilidade e gestão deles? Sendo que se encontram fora da infra local

Não tem infra na nuvem

## 8 - Dado que a empresa utiliza bastante e-mail para comunicação, como é realizada a prevenção contra ataques de phishing a colaboradores?

Tem treinamentos internos para prevenção de phishing

## 9 - Como a empresa lida com dados de pagamentos dos usuários? Quais são as medidas para proteger esses dados?

Segue as medidas descritas na certificação PCI

## 10 - Existe alguma rotina de verificação de vulnerabilidades nos sistemas que a empresa já possui?

Não