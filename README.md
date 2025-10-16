# 🚀 PyHostname - Projeto Completo de Automação DevOps na AWS

[![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)](https://aws.amazon.com)
[![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Ansible](https://img.shields.io/badge/ansible-%231A1918.svg?style=for-the-badge&logo=ansible&logoColor=white)](https://www.ansible.com/)
[![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)
[![GitHub Actions](https://img.shields.io/badge/github%20actions-%232671E5.svg?style=for-the-badge&logo=githubactions&logoColor=white)](https://github.com/features/actions)
[![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54)](https://www.python.org/)

## 📋 Sobre o Projeto

O PyHostname é um projeto de portfólio simples e direto feito para mostrar o processo de automação DevOps completo para provisionar, configurar e implantar uma aplicação web em contêiner na nuvem AWS. A automação é orquestrada por pipelines de CI/CD no GitHub Actions, seguindo as melhores práticas de separação de responsabilidades entre a infraestrutura e a aplicação.

A aplicação base é um simples contador de visitas desenvolvido em Python com o framework Flask, conectado a um banco de dados NoSQL gerenciado (MongoDB Atlas).

---

## ✨ Destaques do Projeto

* **Infraestrutura como Código (IaC):** 100% da infraestrutura na AWS é provisionada e gerenciada de forma declarativa com **Terraform**, garantindo ambientes consistentes e replicaveis de forma rapida.
* **Gerenciamento de Configuração:** **Ansible** é utilizado para automatizar a configuração do servidor (pós-provisionamento), instalando dependências como Docker de forma idempotente.
* **Separação de Pipelines (CI/CD):** O projeto utiliza duas pipelines distintas no **GitHub Actions**, refletindo uma arquitetura DevOps madura:
    * Uma pipeline para o **ciclo de vida da infraestrutura** (Terraform).
    * Uma pipeline para o **ciclo de vida da aplicação** (Docker + Ansible).
* **Gerenciamento Seguro de Segredos:** Todas as credenciais sensíveis (chaves da AWS, chaves SSH, URIs de banco de dados) são gerenciadas de forma segura através do **GitHub Secrets**.
* **Containerização:** A aplicação é empacotada em uma imagem **Docker** otimizada e versionada, com o armazenamento sendo feito no **Amazon ECR (Elastic Container Registry)**.

---

## 🏛️ Arquitetura e Fluxo de Trabalho

O projeto usa duas pipelines independentes, permitindo que a infraestrutura e a aplicação evoluam em ritmos diferentes.

**Pipeline 1: `infra-setup.yml` (Provisionar e Preparar a Infraestrutura)**
* **Gatilho:** Manual (`workflow_dispatch`), acionado por um Engenheiro DevOps.
* **Função:** Cria e prepara todo o ambiente do zero.
* **Fluxo em Dois Estágios:**
    1.  **Job de Terraform:** Provisiona todos os recursos na AWS (EC2, ECR, Security Group, IAM Role, etc.).
    2.  **Job de Ansible (Setup):** Conecta-se à instância recém-criada para instalar e configurar as dependências base (Docker, Docker Compose), deixando o servidor pronto para receber o deploy.

**Pipeline 2: `deploy-app.yml` (Deploy da Aplicação)**
* **Gatilho:** Automático, a cada `git push` com alterações na pasta `app/`.
* **Função:** Constrói e implanta a nova versão da aplicação no ambiente já existente.
* **Fluxo em Dois Estágios (CI/CD):**
    1.  **Job de CI (Build & Push):** Constrói a imagem Docker da aplicação e a envia para o Amazon ECR.
    2.  **Job de CD (Deploy):** Aciona o playbook do Ansible, que se conecta ao servidor, baixa a nova imagem do ECR e reinicia o contêiner da aplicação com zero downtime (conceitual).

---

## 🛠️ Tecnologias Utilizadas

* **Cloud Provider:** AWS (EC2, ECR, VPC, Security Group, IAM)
* **Infraestrutura como Código (IaC):** Terraform
* **Gerenciamento de Configuração:** Ansible
* **CI/CD:** GitHub Actions
* **Containerização:** Docker
* **Aplicação:** Python, Flask, MongoEngine
* **Banco de Dados:** MongoDB Atlas (DBaaS - Database as a Service)

---

## 🚀 Configuração e Execução

**Pré-requisitos:**
1.  Conta na **AWS** com um usuário IAM e credenciais (`Access Key`, `Secret Key`).
2.  Conta no **GitHub**.
3.  Conta no **MongoDB Atlas** com um cluster gratuito criado e configurado para aceitar conexões externas.

**1. Configuração dos Segredos:**
No seu repositório GitHub, vá em `Settings > Secrets and variables > Actions` e cadastre os seguintes segredos:
* `AWS_ACCESS_KEY_ID`: Sua chave de acesso da AWS.
* `AWS_SECRET_ACCESS_KEY`: Sua chave secreta da AWS.
* `ANSIBLE_SSH_PRIVATE_KEY`: O conteúdo da sua chave SSH privada (`.pem` ou similar).
* `MONGO_URI`: A string de conexão do seu cluster MongoDB Atlas (com a senha).
* `EC2_PUBLIC_IP`: (Opcional) Pode ser deixado em branco, pois será gerenciado pelas pipelines.
* `ECR_REPOSITORY_URL`: (Opcional) Pode ser deixado em branco, pois será gerenciado pelas pipelines.

**2. Execução das Pipelines:**
1.  **Criar a Infraestrutura:** Vá para a aba "Actions", selecione a pipeline `1. Provisionar e Preparar a Infraestrutura` e execute-a manualmente com o botão "Run workflow".
2.  **Fazer o Deploy da Aplicação:** Faça uma pequena alteração em qualquer arquivo dentro da pasta `app/` (ex: mude um texto no `pyHostname.py`).
3.  Faça o `commit` e `push` da sua alteração para a branch `main`.
4.  A pipeline `2. Deploy da Aplicação` será acionada automaticamente. Acompanhe a execução na aba "Actions".
5.  Ao final, o IP do servidor será exibido nos logs. Acesse `http://<IP_DA_SUA_EC2>:8080` para ver a aplicação no ar!

**3. Limpeza:**
* Para destruir toda a infraestrutura e evitar custos, execute a pipeline `1. Provisionar e Preparar a Infraestrutura` novamente, mas desta vez, escolha a opção `destroy` no menu.

---