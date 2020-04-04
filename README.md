### jira-rpa-aas
Using Jira (da Atlassian ) to implement RPA (Robot Process Automation) em um modelo aaS ( As a Service)


## 1. Introdução

Este repositório contém os componentes do projeto **jira-rpa-aas**. A solução deste projeto usa e implementa os seguintes conceitos e ferramentas:
* RPA - Robot Process Automation
* Jira Software - Ferramenta de Workflow da Atlassian
* aaS - Entrega como serviço

### 2. Documentação

### 2.1. Diagrama de Caso de Uso (Use Case Diagram)
### 2.1.1. Diagrama de Conexto

O diagrama de Caso de Uso com **Contexto - Jira RPA aaS** do projeto, apresenta as principais **funcionalidades** do projeto, as **entradas** e **saídas** e as **entidades** que interagem com a solução.

![UseCaseDiagram-Context](doc/UseCaseDiagram%20-%20Context%20-%20Jira%20RPA%20aaS.png)

### 2.2. Diagrama de Implantação (Deploy Diagram)
### 2.2.2. Diagrama de Contexto

O diagrama de Implantação com **Contexto - Jira RPA aaS** do projeto, apresenta as principais **componentes**, **nós** e **comunicações** da solução.

![DeployDiagram-Context](doc/DeployDiagram%20-%20Context%20-%20Jira%20RPA%20aaS.png)

### 2.3. Diagrama de Estados e Transições (State Diagram)
### 2.2.3. Diagrama de Contexto

O diagrama de Estados e Transições com **Contexto - Jira RPA aaS** do projeto, apresenta os principais **estados** e **transições** da solução.

![StateDiagram-Context](doc/StateDiagram%20-%20Context%20-%20Jira%20RPA%20aaS.png)

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


### 3.3. Guia para Configuração ###

* n/a


### 3.4. Guia para Teste ###

* n/a


### 3.5. Guia para Implantação ###

* n/a


### 3.6. Guia para Demonstração ###

* n/a

### 3.7. Guia para Execução ###

* Na pasta `.\dist` encontra-se a versão de distribuição, com arquivos de configuração

```cmd
java -jar lean-digital-in-manager.jar -f .\\dist\\param-file.json
```


## Referências ##

* [Material da IBM sobre RPA](https://www.ibm.com/br-pt/automation/rpa?p1=Search&p4=43700052629843287&p5=e&cm_mmc=Search_Google-_-1S_1S-_-LA_BR-_-rpa_e&cm_mmca7=71700000065117446&cm_mmca8=aud-382859943522:kwd-176772556&cm_mmca9=CjwKCAjw4KD0BRBUEiwA7MFNTWazNMU4x-6wijzylZIY0ZBcxdLkT1EZ3q8lX8PHy8jp0ooRJzmQKBoCivkQAvD_BwE&cm_mmca10=427854564440&cm_mmca11=e&gclid=CjwKCAjw4KD0BRBUEiwA7MFNTWazNMU4x-6wijzylZIY0ZBcxdLkT1EZ3q8lX8PHy8jp0ooRJzmQKBoCivkQAvD_BwE&gclsrc=aw.ds)
