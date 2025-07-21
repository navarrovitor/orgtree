class Api::V1::Companies::EmployeesController< Api::V1::ApplicationController
  before_action :set_company

  # GET /api/v1/companies/:company_id/employees
  def index
    pagy_metadata, paginated_records = pagy(@company.employees, items: 10)

    render json: {
      data: ActiveModelSerializers::SerializableResource.new(paginated_records),
      pagy: pagy_metadata
    }
  end

  # POST /api/v1/companies/:company_id/employees
  def create
    @employee = @company.employees.new(employee_params)
    
    if @employee.save
      render json: @employee, status: :created
    else
      render json: @employee.errors, status: :unprocessable_entity
    end
  end

  private

  def set_company
    @company = Company.find(params[:company_id])
  end

  def employee_params
    params.require(:employee).permit(:name, :email, :picture)
  end
end