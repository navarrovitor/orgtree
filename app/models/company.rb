class Company < ApplicationRecord
  # Uma empresa pode ter N funcionários
  has_many :employees, dependent: :destroy
  
  # Uma empresa precisa ter um nome
  validates :name, presence: true
end
