# OrgTree

Uma aplicação full-stack para gerenciamento de organogramas, construída com Ruby on Rails 7 e React, como parte de um desafio de desenvolvimento.

## Tabela de Conteúdos

1.  [Sobre o Projeto](https://github.com/navarrovitor/orgtree#sobre-o-projeto)
2.  [Funcionalidades](https://github.com/navarrovitor/orgtree#funcionalidades)
3.  [Documentação da API (Swagger)](https://github.com/navarrovitor/orgtree#documenta%C3%A7%C3%A3o-da-api-swagger)
4.  [Stack de Tecnologias](https://github.com/navarrovitor/orgtree#stack-de-tecnologias)
5.  [Como Executar o Projeto](https://github.com/navarrovitor/orgtree#como-executar-o-projeto)
6.  [Como Rodar os Testes](https://github.com/navarrovitor/orgtree#como-rodar-os-testes)
7.  [Modelos & Relacionamentos](https://github.com/navarrovitor/orgtree#modelos--relacionamentos)

## Sobre o Projeto

O OrgTree é uma aplicação monolítica composta por um backend **API RESTful em Rails** e um frontend em **React**. O objetivo é fornecer uma ferramenta robusta e escalável para empresas gerenciarem sua estrutura organizacional, funcionários e hierarquias.

## Funcionalidades

  - **Gerenciamento de Empresas:** Cadastro, listagem e visualização de múltiplas empresas no sistema.
  - **Gerenciamento de Colaboradores:** Cadastro, listagem e remoção de colaboradores, sempre associados a uma empresa.
  - **Estrutura Organizacional:**
      - Atribuição de um gestor a um colaborador.
      - Listagem de pares (colegas com o mesmo gestor).
      - Listagem de liderados diretos.
      - Listagem de liderados de segundo nível (liderados dos liderados).
  - **Regras de Negócio:** Validações robustas para garantir a integridade da hierarquia, como:
      - Impedir a criação de loops (ex: um gestor não pode ser liderado por um de seus subordinados).
      - Garantir que gestores e liderados pertençam à mesma empresa.
  - **Paginação (Pagy):** Todos os endpoints de listagem são paginados para garantir performance e escalabilidade, mesmo com um grande volume de dados.
  - **Documentação Interativa (Swagger):** A API é 100% documentada usando Swagger (OpenAPI). Isso permite que qualquer desenvolvedor entenda e teste os endpoints facilmente através de uma interface web.
  - **Tratamento de Erros Centralizado:** Respostas de erro consistentes e padronizadas em toda a API, facilitando a depuração e o tratamento de exceções no frontend.

## Documentação da API (Swagger)

A documentação completa e interativa da API está disponível via Swagger UI.

Após iniciar o servidor backend, acesse:
**[http://localhost:3000/docs](http://localhost:3000/docs)**

## Stack de Tecnologias

### Backend (API)

  - Ruby 3+
  - Ruby on Rails 7 (API-only)
  - **SQLite3** para o banco de dados
  - **Pagy** para paginação
  - **Rswag** para documentação Swagger
  - **RSpec** e **FactoryBot** para testes

### Frontend

  - React
  - Vite
  - Axios (para chamadas à API)
  - React Router (para roteamento)

## Como Executar o Projeto

Para executar o projeto, você precisará clonar o repositório e configurar tanto o backend quanto o frontend.

### Pré-requisitos

  - Ruby
  - Bundler
  - Node.js e npm/yarn

### Backend (API)

```bash
# Navegue até a pasta da API (ex: /api)
cd api

# Instale as dependências
bundle install

# Crie e configure o banco de dados
rails db:create
rails db:migrate

# Popule o banco com dados de exemplo
rails db:seed

# Inicie o servidor Rails na porta 3000
rails s
```

### Frontend

```bash
# Em outro terminal, navegue até a pasta do cliente (ex: /client)
cd client

# Instale as dependências
npm install

# Inicie o servidor de desenvolvimento do React
npm run dev
```

## Como Rodar os Testes

### Testes do Backend

```bash
# A partir da pasta da API
rspec
```

### Testes da Documentação (Swagger)

```bash
# A partir da pasta da API
rake rswag:specs:run
```

## Modelos & Relacionamentos
<img width="872" height="445" alt="image" src="https://github.com/user-attachments/assets/332e2e86-4bff-44d7-8c23-ed7484c581f5" />

  - **Company**: Para representar uma empresa
      - **Atributos**:
          - `name` (string)
      - **`has_many`** `:employees`
  - **Employee**: Para representar um colaborador
      - **Atributos**:
          - `name` (string)
          - `email` (string)
          - `picture` (string)
      - **`belongs_to`** `:company`
      - **`belongs_to`** `:manager`
      - **`has_many`** `:subordinates`

-----

Desenvolvido com ❤️ por navarrovitor
git mv app Gemfile* Rakefile config db lib log public storage test vendor .gitattributes .gitignore .rspec package.json yarn.lock config.ru bin api/