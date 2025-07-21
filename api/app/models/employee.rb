class Employee < ApplicationRecord
  # Um empregado deve pertencer a uma empresa
  belongs_to :company

  # Um empregado deve pertencer a um gestor. É opcional para o caso dele não ter um gestor acima dele 
  belongs_to :manager, class_name: 'Employee', optional: true
  
  # Um empregado pode ter N subordinados. Se o gestor for deletado, seus subordinados ficarão com o campo manager_id nulo 
  has_many :subordinates, class_name: 'Employee', foreign_key: 'manager_id', dependent: :nullify
  
  has_many :second_level_subordinates, through: :subordinates, source: :subordinates 

  # Valida se o empregado tem um nome, email e uma empresa
  validates :name, :email, :company, presence: true

  # Valida se o email do empregado é único considerando os emails presentes na company
  validates :email, uniqueness: { scope: :company_id }

  # Valida regras de negócio
  ## Gestor precisa ser da mesma empresa do empregado 
  validate  :manager_must_be_from_same_company
  
  ## Uma pessoa abaixo de um líder na hierarquia não pode ser líder desse líder
  validate  :prevent_organization_hierarchy_loop
  
  ## O email do empregado deve ter o domínio da empresa
  validate  :email_domain_must_match_company

  private

  def manager_must_be_from_same_company
    if manager.present? && manager.company_id != self.company_id
      errors.add(:manager, "must be in the same company")
    end
  end

  def prevent_organization_hierarchy_loop
    return if manager.blank?

    # Começa a verificação a partir do gestor do gestor.
    current_manager = self.manager
    while current_manager.present?
      # Se encontrarmos o próprio funcionário na hierarquia acima, é um loop.
      if current_manager == self
        errors.add(:manager_id, "creates a organization hierarchy loop")
        break # Sai do loop assim que o erro é encontrado.
      end
      # Move um nível para cima na hierarquia.
      current_manager = current_manager.manager
    end
  end

  def email_domain_must_match_company
    return if company.blank? || email.blank?

    # 1. Constrói o domínio esperado a partir do nome da empresa.
    # Exemplo: "ABCorp" -> "abcorp.com"
    expected_domain = company.name.gsub(/\s+/, "").downcase + ".com"

    # 2. Extrai o domínio do email fornecido para o funcionário.
    actual_domain = email.split('@').last

    # 3. Compara os domínios e adiciona um erro se forem diferentes.
    if actual_domain.downcase != expected_domain
      errors.add(:email, "domain must match the company's domain (#{expected_domain})")
    end
  end
end
