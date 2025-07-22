# Este serializer é usado para evitar loops infinitos na chamada do employee
class BasicEmployeeSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :picture
end