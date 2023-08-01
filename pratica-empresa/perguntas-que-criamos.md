# Objetivo

Levantamento de perguntas pra conhecer sobre o negócio e características tecnológicas

Em paralelo: Descrever a nossa empresa fictícia.

## Perguntas

 Quais produtos e serviços a empresa oferece?

 Qual é o público alvo da empresa?

 Qual a expectativa da empresa sobre esta consultoria de segurança?

 Quantos funcionários diretos a empresa possui?

 A empresa possui terceirizados?

 Quantos computadores a empresa possui?

 A jornada de trabalho é presencial ou remota?

 A empresa já sofreu algum tipo de incidente de segurança?

 A empresa armazena dados sensíveis de acordo com a LGPD?

 A empresa possui um time voltado para a área de segurança?

 A empresa possui sede física?

 A empresa possui uma política de acesso à sede física?

 A sede física possui sistema de monitoramento por câmera?

 A empresa possui um sistema de monitoramento ativo de logs?

 A empresa possui algum plano para recuperação de desastres naturais?

 A empresa possui algum padrão para atualização automática de sistemas operacionais?

 A empresa possui infraestrutura tecnológica (servidores) próprios ou na núvem?

 A empresa depende de tecnologias legadas ou obsoletas para a operação?

### Perguntas extras que roubamos do outro grupo

A empresa possui um firewall nos seus servidores?

A empresa possui um plano de continuidade de negócio?

A empresa possui filiais?

## Empresa fictícia

### Quais produtos e serviços a empresa oferece?

Empresa de processamento de transações de crédito. Oferece uma API para integração.

### Qual é o público alvo da empresa?

O cliente direto são lojistas parceiros que integram com a API, mas o cliente final do lojista também é um público alvo indireto.

### Qual a expectativa da empresa sobre esta consultoria de segurança?

- Garantir a conformidade com a certificação PCI
- Garantir a disponibilidade da API
- Garantir o cumprimento da LGPD

### Quantos funcionários diretos a empresa possui?

100.

### A empresa possui terceirizados?

A empresa terceiriza serviços de limpeza e algumas demandas de desenvolvimento de software.

Os terceirizados da limpeza possuem acesso físico à sede, inclusive em horários em que não tem nenhum funcionário no prédio.

Os terceirizados de desenvolvimento só trabalham remotamente.

### Quantos computadores a empresa possui?

120 para uso dos funcionários.

### A jornada de trabalho é presencial ou remota?

Híbrido, mas a maioria trabalha presencialmente.

### A empresa já sofreu algum tipo de incidente de segurança?

- Tentativa de DDoS bem sucedido
- Vazamento de dados de cartão de crédito (criptografado)
- Um funcionário conectou o notebook da empresa numa rede pública e foi infectado por um malware que se espalhou em alguns outros computadores da VPN
- Um funcionário solicitou reembolso indevido de um cliente para sua conta pessoal

### A empresa armazena dados sensíveis de acordo com a LGPD?

Sim. Dados de cartão de crédito.

### A empresa possui um time voltado para a área de segurança?

Sim. É uma squad dentro do time de infra e possui 3 analistas de segurança.

### A empresa possui sede física?

Sim. É dentro de um centro comercial com várias outras empresas no mesmo prédio.

### A empresa possui uma política de acesso à sede física?

O visitante precisa passar na portaria e solicitar um cartão de acesso que é coletado na saída. O porteiro registra num papel o nome e o CPF do visitante e a referência do cartão de acesso.

O funcionário possui um crachá com RFID que libera a porta automaticamente.

### A sede física possui sistema de monitoramento por câmera?

Não.

### A empresa possui um sistema de monitoramento ativo de logs?

As aplicações registram logs, mas não são monitorados ativamente.

### A empresa possui algum plano para recuperação de desastres naturais?

Sim. Existe redundância em 3 continentes diferentes.

### A empresa possui algum padrão para atualização automática de sistemas operacionais?

O time de infra gerencia a atualização automática dos computadores.

### A empresa possui infraestrutura tecnológica (servidores) próprios ou na núvem?

Tudo infra própria, sem núvem.

### A empresa depende de tecnologias legadas ou obsoletas para a operação?

- Windows Server 2012
- SQL Server 2008
- dotnet core 2

