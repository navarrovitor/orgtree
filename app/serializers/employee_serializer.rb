class EmployeeSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :picture

  # Para as associações, usamos o serializer básico para evitar loops.
  belongs_to :manager, serializer: BasicEmployeeSerializer
  has_many :subordinates, serializer: BasicEmployeeSerializer
end