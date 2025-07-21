class CompanySerializer < ActiveModel::Serializer
  attributes :id, :name

  # Quando um único registro de Company for serializado,
  # esta linha incluirá um array de seus funcionários.
  has_many :employees
end