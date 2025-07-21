ActiveRecord::Base.transaction do
  puts "Cleaning database..."
  Employee.destroy_all
  Company.destroy_all

  puts "Creating companies..."
  abcorp = Company.create!(name: "ABCorp")

  ghinc = Company.create!(name: "GHInc")

  puts "Creating employees for ABCorp..."

  # CEO
  ceo_one = abcorp.employees.create!(
    name: "Catarina",
    email: "catarina@abcorp.com",
    picture: "foto_catarina"
  )

  # Diretores (reportam ao CEO)
  director_one = abcorp.employees.create!(
    name: "Daniel",
    email: "daniel@abcorp.com",
    manager: ceo_one,
    picture: "foto_daniel"
  )

  director_two = abcorp.employees.create!(
    name: "Patricia",
    email: "patricia@abcorp.com",
    manager: ceo_one,
    picture: "foto_patricia"
  )
  
  # Diretor sem liderados diretos
  director_three = abcorp.employees.create!(
    name: "Leonardo",
    email: "leonardo@abcorp.com",
    manager: ceo_one,
    picture: "foto_leonardo"
  )

  # Gerentes (reportam aos Diretores)
  manager_one = abcorp.employees.create!(
    name: "Fernanda",
    email: "fernanda@abcorp.com",
    manager: director_one,
    picture: "foto_fernanda"
  )

  manager_two = abcorp.employees.create!(
    name: "Bruno",
    email: "bruno@abcorp.com",
    manager: director_one,
    picture: "foto_bruno"
  )

  manager_three = abcorp.employees.create!(
    name: "Diego",
    email: "diego@abcorp.com",
    manager: director_two,
    picture: "foto_diego"
  )

  # Colaboradores (reportam aos Gerentes)
  abcorp.employees.create!(
    name: "Rafael",
    email: "rafael@abcorp.com",
    manager: manager_one,
    picture: "foto_rafael"
  )

  abcorp.employees.create!(
    name: "Viviane",
    email: "viviane@abcorp.com",
    manager: manager_one,
    picture: "foto_viviane"
  )

  abcorp.employees.create!(
    name: "Ricardo",
    email: "ricardo@abcorp.com",
    manager: manager_two,
    picture: "foto_ricardo"
  )

  abcorp.employees.create!(
    name: "Paula",
    email: "paula@abcorp.com",
    manager: manager_two,
    picture: "foto_paula"
  )

  abcorp.employees.create!(
    name: "Nelson",
    email: "nelson@abcorp.com",
    manager: manager_two,
    picture: "foto_nelson"
  )

  abcorp.employees.create!(
    name: "Felipe",
    email: "felipe@abcorp.com",
    manager: manager_three,
    picture: "foto_felipe"
  )

  puts "Creating employees for GHInc..."

  ceo_two = ghinc.employees.create!(
    name: "Otavio",
    email: "otavio@ghinc.com",
    picture: "foto_otavio"
  )

  ghinc.employees.create!(
    name: "Davi",
    email: "davi@ghinc.com",
    manager: ceo_two,
    picture: "foto_davi"
  )
  
  puts "Seed finished!"
  puts "#{Company.count} companies created."
  puts "#{Employee.count} employees created."
end