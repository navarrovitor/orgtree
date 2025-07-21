class EmployeeSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :picture

  # Para as associações, usamos o serializer básico para evitar loops.
  # Na requisição de empregado, ele virá com dados completos. Os dados do gestor e subordinados, virão com menos dados (id, name, email)
  belongs_to :manager, serializer: BasicEmployeeSerializer
  has_many :subordinates, serializer: BasicEmployeeSerializer
end