class Api::V1::CompaniesController< Api::V1::ApplicationController
  def index
    @companies = Company.all
    render json: @companies
  end

  def show
    pagy_metadata, paginated_records = pagy(Company.all, items: 10)

    render json: {
      data: ActiveModelSerializers::SerializableResource.new(paginated_records),
      pagy: pagy_metadata
    }
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