class CompanySerializer < ActiveModel::Serializer
  attributes :id, :name

  has_many :employees, serializer: EmployeeSerializer
end