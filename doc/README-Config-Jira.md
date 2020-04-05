### README-Config-Jira.md
Guia de Configuração da ferramenta Jira para o projeto [Jira RPA aaS](../README.md)

Índice

* [Passo a Passo](#1-passo-a-passo)
  * [Criar Projeto](#11-criar-projeto)
  * [Configurar Tipos de Ocorrências para as pendências do projeto](#12-configurar-tipos-de-ocorrências-para-as-pendências-do-projeto)
# 1. Passo a Passo

## 1.1. Criar Projeto

* No menu `Pojeto >> Criar Projeto` escolha `Desenvolvimento de software básico` e clique no botão `Próximo`

![Config-Jira-CriarProjeto-01.png](printscreen/Config-Jira-CriarProjeto-01.png)

* Na caixa de diálogo `Criar Projeto` confirme as opções existentes e clique no botão `Próximo`

![Config-Jira-CriarProjeto-02.png](printscreen/Config-Jira-CriarProjeto-02.png)

* Na caixa de diálogo `Desenvolvimento de software Básico` preencha os campos/valores abaixo e clique no botão `Enviar`
  * Nome: `RPA`
  * Chave: `RAPA`

![Config-Jira-CriarProjeto-03.png](printscreen/Config-Jira-CriarProjeto-03.png)

* No página `Ocorrências abertas` observar o projeto criado

![Config-Jira-OcorrenciasAbertas-01.png](printscreen/Config-Jira-OcorrenciasAbertas-01.png)

---

## 1.2. Configurar Tipos de Ocorrências para as pendências do projeto

* No menu superior principal clique no link do item de menu `Administração >> Pendências`
* Na página de `Administração` na aba `Pendências` observar os itens do `sub-menu de Configurações de Pendências`

![Config-Jira-AdminPendencia-01.png](printscreen/Config-Jira-AdminPendencia-01.png)
![Config-Jira-AdminPendencia-02.png](printscreen/Config-Jira-AdminPendencia-02.png)

* Na página de `Configurações do Pendências` clicar no item do sub-menu `Tipos de Ocorrências`
* Na página de `Configurações do Pendências` no sub-menu `Tipos de Ocorrências` clicar no botão `Adicionar Tipos de Ocorrências`
* Na caixa de diálogo `Adicionar Tipo de Item` preencha os campos/valores abaixo e clique no botão `Adicionar`
  * Nome: `RPA`
  * Descrição: `RPA`
  * Tipo: `Tipo de Issue padrão`

![Config-Jira-AdminPendenciaCriarTipoItemOcorrencia-01.png](printscreen/Config-Jira-AdminPendenciaCriarTipoItemOcorrencia-01.png)

* Na página de `Configurações do Pendências` no sub-menu `Esquemas de Tipos de Ocorrências` clicar no botão `Adicionar Tipos de Ocorrências` clicar no link `Editar` correspondente ao nome `RPA: Esquema de Tipo de Item para Desenvolvimento de Software`

![Config-Jira-AdminPendenciaConfigurarEsquemaDeTipoDeOcorrencia-01.png](printscreen/Config-Jira-AdminPendenciaConfigurarEsquemaDeTipoDeOcorrencia-01.png)

* Na página de `Configurações do Pendências` no sub-menu `Esquemas de Tipos de Ocorrências` na aba `Modify Esquema de Tipo de Item` arrastar e soltar nas lista `Tipos de Itens para o actual regime` e  `Disponível Tipo de Itens` de forma que ao final sobre apenas o tipo de item `RPA` na lista `Tipos de Itens para o actual regime`. Em seguida clique no botão `Salvar`	

![Config-Jira-AdminPendenciaConfigurarEsquemaDeTipoDeOcorrencia-02.png](printscreen/Config-Jira-AdminPendenciaConfigurarEsquemaDeTipoDeOcorrencia-02.png)
![Config-Jira-AdminPendenciaConfigurarEsquemaDeTipoDeOcorrencia-03.png](printscreen/Config-Jira-AdminPendenciaConfigurarEsquemaDeTipoDeOcorrencia-03.png)


---

[README Home page](../README.md)

