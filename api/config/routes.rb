Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/docs'
  mount Rswag::Api::Engine => '/docs'
  namespace :api do
    namespace :v1 do

      # Rotas para Empresas.
      # GET   /api/v1/companies
      # POST  /api/v1/companies
      # GET   /api/v1/companies/:id
      resources :companies, only: [:index, :show, :create] do
        # Ações que DEPENDEM do contexto da empresa.
        # GET   /api/v1/companies/:company_id/employees (Listar colaboradores da empresa)
        # POST  /api/v1/companies/:company_id/employees (Criar colaborador na empresa)
        resources :employees, only: [:index, :create], controller: 'companies/employees'
      end

      # Rotas que operam sobre um COLABORADOR específico, identificado pelo seu ID.
      # DELETE /api/v1/employees/:id (Apagar um colaborador)
      resources :employees, only: [:destroy] do
        # Ações do organograma sobre um colaborador específico (:id).
        # POST  /api/v1/employees/:id/assign_manager
        # GET   /api/v1/employees/:id/peers
        # GET   /api/v1/employees/:id/subordinates
        # GET   /api/v1/employees/:id/second_level_subordinates
        member do
          post 'assign_manager'
          get 'peers'
          get 'subordinates'
          get 'second_level_subordinates'
        end
      end

    end
  end
end