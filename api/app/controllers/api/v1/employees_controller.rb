class Api::V1::EmployeesController < Api::V1::ApplicationController
  before_action :set_employee, only: [:destroy, :peers, :subordinates, :second_level_subordinates, :assign_manager]

  def destroy
    @employee.destroy
    head :no_content
  end

  def assign_manager
    manager_id = params[:manager_id]
    manager = manager_id.present? ? Employee.find(manager_id) : nil

    @employee.manager = manager

    if @employee.save
      render json: @employee, status: :ok
    else
      render json: { errors: @employee.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def peers
    if @employee.manager.present?
      peers = @employee.manager.subordinates.where.not(id: @employee.id)
      render json: peers
    else
      render json: []
    end
  end

  def subordinates
    render json: @employee.subordinates
  end

  def second_level_subordinates
    render json: @employee.second_level_subordinates
  end

  private

  def set_employee
    @employee = Employee.find(params[:id])
  end
end