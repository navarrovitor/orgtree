# OrgTree
O OrgTree é uma ferramenta para gerenciar organogramas de empresas de maneira simples e fácil de usar, construída com Rails 7.

# Funcionalidades
- SQLite3 para o banco de dados
# Modelos & Relacionamentos
<img width="872" height="445" alt="image" src="https://github.com/user-attachments/assets/332e2e86-4bff-44d7-8c23-ed7484c581f5" />

- **Company**: Para representar uma empresa
  - **Atributos**:
    - name (string)
  - **has_many** :employees
- **Employee**: Para representar um colaborador
  - **Atributos**:
    - name (string)
    - email (string)
    - picture (string) # TODO
  - **belongs_to** :company
  - **belongs_to** :manager
  - **has_many** :subordinates

Desenvolvido com ❤️ por navarrovitor
