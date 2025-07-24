# OrgTree

Uma aplicação full-stack para gerenciamento de organogramas, construída com Ruby on Rails 7 e React.

## Tabela de Conteúdos
1. [Sobre o Projeto](#sobre-o-projeto)
2. [Modelos & Relacionamentos](#modelos--relacionamentos)
3. [Funcionalidades](#funcionalidades)
4. [Decisões de Arquitetura](#decisões-de-arquitetura)
5. [Documentação da API (Swagger)](#documentação-da-api-swagger)
6. [Stack de Tecnologias](#stack-de-tecnologias)
7. [Como Executar o Projeto](#como-executar-o-projeto)
8. [Como Rodar os Testes](#como-rodar-os-testes)

## Sobre o Projeto
O OrgTree é uma aplicação monolítica composta por um backend **API RESTful em Rails** e um frontend em **React**. O objetivo é fornecer uma ferramenta robusta e escalável para empresas gerenciarem sua estrutura organizacional, funcionários e hierarquias. O frontend é servido pela Vercel e a API pelo Render.

## Modelos e Relacionamentos
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

## Funcionalidades
- **Gerenciamento de Empresas:** Cadastro e listagem de múltiplas empresas.
- **Visualização de Organograma:**
  -   Visualização da hierarquia de funcionários em formato de árvore.
  -   Capacidade de expandir e colapsar ramos da árvore.
- **Gerenciamento de Colaboradores:**
  -   Cadastro e remoção de colaboradores em uma empresa.
  -   Atribuição de um gestor a um colaborador de forma interativa.
- **Funcionalidades Extras:**
  -   **Paginação** em todos os endpoints de listagem para garantir performance.
  -   **Documentação Interativa da API** com Swagger (Rswag).
  -   **Modo Claro / Escuro (Dark Mode)** com persistência da preferência do usuário.
  -   **Layout Responsivo** com Header e Footer fixos.

## Decisões de Arquitetura
- **Separação Backend/Frontend:** A API Rails é totalmente desacoplada do cliente React, comunicando-se via REST. Isso permite que cada parte seja desenvolvida, testada e implantada de forma independente.
- **Gerenciamento de Estado no Frontend:** Foi utilizada a biblioteca **React Query (TanStack Query)** para gerenciar o "estado do servidor". Essa abordagem simplifica drasticamente a lógica de fetching, caching e atualização de dados, eliminando a necessidade de ferramentas mais complexas como Redux para este caso de uso. O estado de UI (como o tema claro/escuro) é gerenciado pelo Context API do React.
- **Plataformas de Deploy:** **Vercel** foi escolhida para o frontend por sua otimização para aplicações estáticas e JAMstack. **Render** foi escolhido para o backend por sua simplicidade, compatibilidade com Rails e por oferecer um banco de dados PostgreSQL gratuito.

## Documentação da API (Swagger)
A documentação completa e interativa da API está disponível no endpoint da API no Render.
**[Documentação da API](https://orgtree-api.onrender.com/docs)**

Ou localmente via localhost.
**[http://localhost:3000/docs](http://localhost:3000/docs)**

## Stack de Tecnologias
- **Backend:** Ruby on Rails 7, PostgreSQL, RSpec, FactoryBot, Pagy, Rswag.
- **Frontend:** React, Vite, Tailwind CSS, Axios, React Router, TanStack Query.
- **Plataformas:** Vercel (Frontend), Render (Backend).

## Como Executar o Projeto
Siga os passos abaixo para configurar e rodar o projeto localmente.

### Pré-requisitos
- Ruby e Bundler
- Node.js e NPM/Yarn
- PostgreSQL

### Backend (API)
```bash
# Navegue até a pasta da API
cd api

# Instale as dependências
bundle install

# Crie e configure o banco de dados
rails db:create
rails db:migrate

# Popule o banco com dados de exemplo
rails db:seed

# Inicie o servidor Rails
rails s
```

### Frontend
```bash
# Em outro terminal, navegue até a pasta do cliente
cd client

# Instale as dependências
npm install

# Inicie o servidor de desenvolvimento
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
rake rswag:specs:swaggerize
```

---
Desenvolvido com ❤️ por [navarrovitor](https://github.com/navarrovitor)