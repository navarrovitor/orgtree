class Api::V1::EmployeesController < Api::V1::ApplicationController
  before_action :set_employee, only: [:destroy, :peers, :subordinates, :second_level_subordinates, :assign_manager]

  # DELETE /api/v1/employees/:id
  def destroy
    @employee.destroy
    head :no_content # Retorna uma resposta 204 No Content
  end

  # POST /api/v1/employees/:id/assign_manager
  # Corpo da requisição esperado: { "manager_id": <id_do_novo_gestor> }
  # A User Story 3.1 pede para "associar um colaborador como gestor de outro usuário"
  def assign_manager
    manager_id = params.require(:manager_id)
    manager = Employee.find(manager_id)

    @employee.manager = manager

    if @employee.save
      render json: @employee, status: :ok
    else
      render json: { errors: @employee.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # GET /api/v1/employees/:id/peers
  def peers
    # A User Story 3.2 pede para "listar os pares de um colaborador"
    if @employee.manager.present?
      # Tira o próprio funcionário da lista
      peers = @employee.manager.subordinates.where.not(id: @employee.id)
      render json: peers
    else
      render json: []
    end
  end

  # GET /api/v1/employees/:id/subordinates
  def subordinates
    # A User Story 3.3 pede para "listar os liderados diretos de um colaborador"
    render json: @employee.subordinates
  end

  # GET /api/v1/employees/:id/second_level_subordinates
  def second_level_subordinates
    # A User Story 3.4 pede para "listar os liderados dos liderados de um colaborador"
    render json: @employee.second_level_subordinates
  end

  private

  def set_employee
    @employee = Employee.find(params[:id])
  end
end