### jira-rpa-aas
Using Jira (da Atlassian ) to implement RPA (Robot Process Automation) em um modelo aaS ( As a Service)

## 1. Introdução

Este repositório contém os componentes do projeto **jira-rpa-aas**. A solução **jira-rpa-aas** usa e implementa os seguintes conceitos e ferramentas:
* RPA - Robot Process Automation
* Jira Software - Ferramenta de Workflow da Atlassian
* aaS - Entrega como serviço

### 1.1. Índice

* [Documentação](#2-documentação)
  * [Introdução](#21-introdução)
  * [Diagrama de Caso de Uso](#22-diagrama-de-caso-de-uso-use-case-diagram)
  * [Diagrama de Implantação](#23-diagrama-de-implantação-deploy-diagram)
  * [Diagrama de Estados e Transições](#24-diagrama-de-estados-e-transições-state-diagram)
  * [Requisitos](#25-requisitos)
* Projeto
  * [Pré-Requisitos](#31-pré-requisitos)
  * [Guia para Desenvolvimento](#32-guia-para-desenvolvimento)
  * [Guia para Configuração](#33-guia-para-configuração)
    * [Configuração do Jira](#331-configuração-do-jira)
  * [Guia para Testes](#34-guia-para-teste)
  * [Guia para Implantação](#35-guia-para-implantação)
  * [Guia para Demonstração](#36-guia-para-demonstração)
  * [Guia para Execução](#37-guia-para-execução)


### 2. Documentação

### 2.1. Introdução

O contexto de negócio resolvido por este projeto é robotizar e automatizar o seguinte processo:
* Permitir que _Solicitantes_ submetam arquivos de _input_ para processamento
* O _Executor do Trabalho_ receba os arquivos de _input_ e realiza o processamento
* O _Executor do Trabalho_ atualiza o status e anexa os arquivos de _output_ do processamento

![BusinessDiagram-Context](doc/BusinessDiagram%20-%20Context.png)


### 2.2. Diagrama de Caso de Uso (Use Case Diagram)
### 2.2.1. Diagrama de Contexto

O diagrama de Caso de Uso com **Contexto - Jira RPA aaS** do projeto, apresenta as principais **funcionalidades** do projeto, as **entradas** e **saídas** e as **entidades** que interagem com a solução.

![UseCaseDiagram-Context](doc/UseCaseDiagram%20-%20Context.png)

### 2.3. Diagrama de Implantação (Deploy Diagram)
### 2.3.2. Diagrama de Contexto

O diagrama de Implantação com **Contexto - Jira RPA aaS** do projeto, apresenta as principais **componentes**, **nós** e **comunicações** da solução.

![DeployDiagram-Context](doc/DeployDiagram%20-%20Context.png)

### 2.4. Diagrama de Estados e Transições (State Diagram)
### 2.4.3. Diagrama de Contexto

O diagrama de Estados e Transições com **Contexto - Jira RPA aaS** do projeto, apresenta os principais **estados** e **transições** da solução.

![StateDiagram-Context](doc/StateDiagram%20-%20Context.png)

### 2.5. Requisitos ###

* Jira-Software - Componente de Software da Atlassian
* Jira-Software Scripts


## 3. Projeto ##

### 3.1. Pré-requisitos ###

* [Install Jira Software](https://github.com/josemarsilva/eval-virtualbox-vm-ubuntu-server#324-atlassian-jira-software-e-jira-core-for-linux-ubuntu)


### 3.2. Guia para Desenvolvimento ###

* Obtenha o código fonte através de um "git clone". Utilize a branch "master" se a branch "develop" não estiver disponível.
* Faça suas alterações, commit e push na branch "develop".
* Crie a seguinte configuração de _Run Configurations_ no eclipse:


### 3.3. Guia para Configuração

### 3.3.1. Configuração do Jira

* [Guia para Configuração do Jira](doc/README-Config-Jira.md)


### 3.3.2. Configuração do Agendador de Tarefa do Windows executar o Process Worker

* [Guia para Configuração do Agendador de Tarefa do Windows executar o Process Worker](doc/README-Config-Agendador-Tarefas-Windows.md)


### 3.4. Guia para Teste

* n/a


### 3.5. Guia para Implantação

* n/a


### 3.6. Guia para Demonstração

* n/a

### 3.7. Guia para Execução

* n/a

### 3.7.1. Guia do Usuário

* n/a

### 3.7.2. Guia do Administrador

* n/a


## Referências ##

* [Material da IBM sobre RPA](https://www.ibm.com/br-pt/automation/rpa?p1=Search&p4=43700052629843287&p5=e&cm_mmc=Search_Google-_-1S_1S-_-LA_BR-_-rpa_e&cm_mmca7=71700000065117446&cm_mmca8=aud-382859943522:kwd-176772556&cm_mmca9=CjwKCAjw4KD0BRBUEiwA7MFNTWazNMU4x-6wijzylZIY0ZBcxdLkT1EZ3q8lX8PHy8jp0ooRJzmQKBoCivkQAvD_BwE&cm_mmca10=427854564440&cm_mmca11=e&gclid=CjwKCAjw4KD0BRBUEiwA7MFNTWazNMU4x-6wijzylZIY0ZBcxdLkT1EZ3q8lX8PHy8jp0ooRJzmQKBoCivkQAvD_BwE&gclsrc=aw.ds)
