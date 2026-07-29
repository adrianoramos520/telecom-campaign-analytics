# Telecom Campaign Analytics

Projeto de portfólio voltado à aplicação de Marketing Analytics, CRM e Customer Intelligence no segmento de telecomunicações. 

## Objetivo

Simular uma operação de dados para campanhas de uma empresa de telecom, utilizando uma base fictícia de clientes para:

- construir audiências;
- aplicar regras de elegibilidade e exclusão;
- controlar a quantidade de campanhas recebidas;
- analisar consumo, recargas, faturas e interações;
- identificar clientes com risco de churn;
- criar grupos de teste e controle;
- avaliar performance de campanhas;
- desenvolver modelos de propensão.

## Tecnologias

- Google BigQuery
- SQL
- Python
- Power BI
- GitHub

## Estrutura dos dados

A base contém informações fictícias sobre:

- clientes;
- planos;
- consumo mensal;
- recargas;
- faturas;
- campanhas;
- interações;
- consentimentos;
- churn;
- propensão de resposta.

## Status do projeto

Em desenvolvimento.

### Etapa atual

- [x] Criação da base fictícia
- [x] Criação do projeto no BigQuery
- [x] Criação do dataset
- [ ] Ingestão das tabelas
- [ ] Validação da qualidade dos dados
- [ ] Construção da primeira audiência
- [ ] Análise de campanha
- [ ] Teste A/B
- [ ] Modelo de propensão
- [ ] Dashboard em Power BI

## Autor

Adriano Ramos



## Primeira audiência — Reativação de clientes pré-pagos

A primeira campanha do projeto tem como objetivo identificar clientes pré-pagos sem recarga há mais de 30 dias.

### Regras iniciais

- cliente com plano pré-pago;
- última recarga realizada há mais de 30 dias, ou ausência de recarga;
- consentimento de marketing ativo.

### Resultado da segmentação

| Etapa | Clientes |
|---|---:|
| Audiência comportamental | 815 |
| Audiência com consentimento | 671 |
| Excluídos sem consentimento | 144 |
| Percentual acionável | 82,33% |

A aplicação da regra de consentimento reduziu a audiência em 17,67%, mantendo 671 clientes aptos para a próxima etapa da campanha.


### Controle de pressão de contato

Após a aplicação do consentimento, foi adicionada uma regra para excluir clientes que receberam alguma campanha nos sete dias anteriores.

| Etapa | Clientes |
|---|---:|
| Audiência com consentimento | 671 |
| Excluídos por campanha recente | 72 |
| Audiência final | 599 |

A regra de pressão de contato reduziu a audiência em 10,73%, mantendo 89,27% dos clientes aptos para o disparo.


### Distribuição por canal preferido

A audiência final foi distribuída de acordo com o canal preferido informado por cada cliente.

| Canal | Clientes | Participação |
|---|---:|---:|
| WhatsApp | 180 | 30,05% |
| SMS | 144 | 24,04% |
| Push | 123 | 20,53% |
| E-mail | 77 | 12,85% |
| Outbound | 47 | 7,85% |
| URA | 28 | 4,67% |
| **Total** | **599** | **100,00%** |

Os canais WhatsApp, SMS, Push e e-mail concentram 524 clientes, correspondendo a 87,47% da audiência final. Isso indica uma oportunidade de priorizar canais digitais e automatizados, reduzindo o custo operacional da campanha.

Os canais Outbound e URA representam 75 clientes, ou 12,52% da audiência, e podem ser direcionados para segmentos de maior valor ou clientes com maior probabilidade de conversão.
