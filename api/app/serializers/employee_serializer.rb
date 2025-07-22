class EmployeeSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :picture, :subordinates, :manager

  belongs_to :manager, serializer: BasicEmployeeSerializer

  has_many :subordinates, serializer: BasicEmployeeSerializer
end