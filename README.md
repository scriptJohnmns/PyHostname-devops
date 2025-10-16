# 🚀 PyHostname - Projeto de DevOps End-to-End na AWS

[![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)](https://aws.amazon.com)
[![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Ansible](https://img.shields.io/badge/ansible-%231A1918.svg?style=for-the-badge&logo=ansible&logoColor=white)](https://www.ansible.com/)
[![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)
[![GitHub Actions](https://img.shields.io/badge/github%20actions-%232671E5.svg?style=for-the-badge&logo=githubactions&logoColor=white)](https://github.com/features/actions)
[![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54)](https://www.python.org/)

## 📋 Sobre o Projeto

O PyHostname é um projeto de portfólio que demonstra um pipeline de automação completo (CI/CD) para provisionar uma infraestrutura na AWS e implantar uma aplicação web em contêiner de forma 100% automatizada. O objetivo é simular um ambiente DevOps moderno, onde a infraestrutura é tratada como código (IaC) e a entrega de software é contínua e segura.

A aplicação é um simples contador de visitas em Python/Flask, conteinerizado com Docker e conectado a um banco de dados NoSQL gerenciado (MongoDB Atlas).

---

## 🏛️ Arquitetura

O projeto é orquestrado por duas pipelines distintas no GitHub Actions, separando o ciclo de vida da infraestrutura e da aplicação:

**Pipeline 1: `infra-setup.yml` (Provisionar e Preparar a Infraestrutura)**
* **Gatilho:** Manual (via `workflow_dispatch`).
* **Função:** Cria toda a base necessária na AWS.
* **Fluxo:**
    1.  **Terraform:** Provisiona a instância EC2, o repositório ECR, o Security Group, a IAM Role e a chave SSH.
    2.  **Ansible (Setup):** Conecta-se à instância recém-criada para instalar e configurar as dependências base (Docker, Docker Compose).
* **Resultado:** Um servidor pronto e configurado, aguardando a aplicação.

**Pipeline 2: `deploy.yml` (Deploy da Aplicação)**
* **Gatilho:** Automático (a cada `git push` na pasta `app/`).
* **Função:** Constrói a nova versão da aplicação e a implanta no servidor.
* **Fluxo:**
    1.  **CI (Build & Push):** Constrói a imagem Docker da aplicação e a envia para o Amazon ECR.
    2.  **CD (Deploy):** Aciona o playbook do Ansible, que se conecta ao servidor, baixa a nova imagem do ECR e reinicia o contêiner da aplicação.
* **Resultado:** A nova versão da aplicação no ar em poucos minutos.

![Diagrama de Arquitetura](https://link-para-sua-imagem-do-diagrama.com)  
*(Dica: Crie um diagrama simples em uma ferramenta como o diagrams.net ou Excalidraw e coloque o link aqui. Isso impressiona muito!)*

---

## 🛠️ Tecnologias Utilizadas

* **Cloud:** AWS (EC2, ECR, VPC, Security Group, IAM)
* **Infraestrutura como Código (IaC):** Terraform
* **Gerenciamento de Configuração:** Ansible
* **CI/CD:** GitHub Actions
* **Containerização:** Docker
* **Aplicação:** Python (Flask), MongoEngine
* **Banco de Dados:** MongoDB Atlas (DBaaS)

---

## 🚀 Como Executar

**Pré-requisitos:**
1.  Conta na AWS com um usuário IAM e credenciais (`Access Key`, `Secret Key`).
2.  Conta no GitHub.
3.  Conta no MongoDB Atlas com um cluster gratuito criado.

**Configuração:**
1.  Faça um "Fork" deste repositório.
2.  No seu repositório "forkado", vá em `Settings > Secrets and variables > Actions` e cadastre os seguintes segredos:
    * `AWS_ACCESS_KEY_ID`: Sua chave de acesso da AWS.
    * `AWS_SECRET_ACCESS_KEY`: Sua chave secreta da AWS.
    * `GH_PAT`: Um Personal Access Token do GitHub com escopo `repo`.
    * `ANSIBLE_SSH_PRIVATE_KEY`: O conteúdo da sua chave SSH privada permanente.
    * `MONGO_URI`: A string de conexão do seu cluster MongoDB Atlas.

**Execução:**
1.  **Criar a Infraestrutura:** Vá para a aba "Actions", selecione a pipeline `1. Provisionar e Preparar a Infraestrutura` e execute-a manualmente com o botão "Run workflow".
2.  **Fazer o Deploy:** Faça uma pequena alteração em qualquer arquivo dentro da pasta `app/` (ex: mude um texto no `pyHostname.py`).
3.  Faça o `commit` e `push` da sua alteração.
4.  A pipeline `2. Deploy da Aplicação` será acionada automaticamente. Acompanhe a execução na aba "Actions".
5.  Ao final, acesse `http://<IP_DA_SUA_EC2>:8080` e veja a aplicação no ar!
6.  **Limpeza:** Para destruir toda a infraestrutura e evitar custos, execute a pipeline `1. Provisionar e Preparar a Infraestrutura` novamente, mas desta vez, escolha a opção `destroy` no menu.

---

## 🧠 Principais Aprendizados

* Gerenciamento de infraestrutura declarativa com **Terraform**.
* Automação da configuração de servidores com **Ansible** e playbooks idempotentes.
* Criação de pipelines de CI/CD robustas e separadas com **GitHub Actions**.
* Integração segura entre ferramentas usando **GitHub Secrets**.
* Ciclo de vida completo de uma aplicação em contêiner, do código ao deploy em nuvem.