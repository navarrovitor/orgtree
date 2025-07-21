class Api::V1::CompaniesController < Api::V1::ApplicationController
  def index
    companies_scope = Company.includes(:employees)
    pagy_metadata, paginated_records = pagy(companies_scope)

    render json: {
      data: ActiveModelSerializers::SerializableResource.new(paginated_records),
      pagy: pagy_metadata
    }
  end

  def show
    @company = Company.find(params[:id])
    render json: @company
  end

  def create
    @company = Company.new(company_params)
    if @company.save
      render json: @company, status: :created
    else
      render json: @company.errors, status: :unprocessable_entity
    end
  end

  private

  def company_params
    params.require(:company).permit(:name)
  end
end