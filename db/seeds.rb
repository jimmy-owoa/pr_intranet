puts("/////////// Inicio carga de datos de prueba ///////////")

# - - - - - - - - - - ROLES - - - - - - - - - -
puts("******* Creando Roles *******")
Role.find_or_create_by(name: "helpcenter", label_name: "Centro de ayuda")
Role.find_or_create_by(name: "admin", label_name: "Administrador")

# # - - - - - - - - - - USUARIO ADMINISTRADOR - - - - - - - - - -
# puts("******* Creando Usuario admin *******")

Location::Country.create(name: 'Chile')

Helpcenter::TicketState.create(status: 'open')
Helpcenter::TicketState.create(status: 'aprobado')
Helpcenter::TicketState.create(status: 'attended')
Helpcenter::TicketState.create(status: 'closed')

if General::User.find_by(email: "admin@exaconsultores.cl").nil?
  user_admin = General::User.create(
    name: "Admin Exa",
    last_name: "sa",
    email: "admin@exaconsultores.cl", 
    password: "exaConsultores", 
    password_confirmation: "exaConsultores",  
    legal_number: "1",
    id_exa: 9999,
    country_id: 1
  )

  user_admin.add_role :admin
end

# STEP 1
data = JSON.parse(File.read("public/compass_users.json")); nil
count = data.count
# STEP 2
def set_email
  email = "#{((0...8).map { (65 + rand(26)).chr }.join).downcase}@compass.cl"
  if General::User.find_by(email: email).present?
    set_email
  end
  email
end
# STEP 3
data.each_with_index do |user, i|
  if user["email"].present?
    email = user["email"]
  else
    email = set_email
  end

  puts("#{set_email}")
  puts "====== Quedan #{count - i} usuarios por cargar ======="
  puts "Cargando usuario: #{email}"
  hash = {}
  hash[:email] = email
  hash[:id_exa] = user["id_exa"]
  hash[:legal_number] = user["legal_number"]
  hash[:name] = user["name"]
  hash[:last_name] = user["last_name"]
  hash[:last_name2] = user["last_name2"]
  hash[:position] = user["cargo"]
  hash[:id_exa_boss] = user["id_exa_boss"]
  office_address = user["office_address"]
  hash[:country] = Location::Country.where(name: office_address).first_or_create
  record = General::User.find_by(id_exa: hash[:id_exa])
  if(record.present?)
    puts "Usuario a actualizar. ID: #{record.id} - EMAIL: #{record.email}"
    if record.update(hash)
      puts "Actualizado correctamente."
    else
      puts "Error: #{record.errors}"
    end
  else
    General::User.create!(hash)
    puts "++Usuario creado. EMAIL: #{hash[:email]}"
  end
end

puts("* * * * * * * Seteando atributos de usuario * * * * * * *")
General::User.all.each {|u| u.set_user_attributes }

# - - - - - - - - - - PERFILES - - - - - - - - - -
puts("******* Creando perfil: General *******")
General::Profile.find_or_create_by(name: "General")

# - - - - - - - - - - CATEGORIAS - - - - - - - - - -
puts("******* Creando Categorias y preguntas centro de ayuda *******")
categories = [
  {
    name: "Beneficios", 
    subcategories: [
      { 
        name: "Bono nacimiento",
        questions: [
          { name: "¿Qué es el bono de nacimiento?" },
          { name: "Requisitos bono nacimiento" },
          { name: "Recomendaciones bono nacimiento" }
        ]
      },
      {
        name: "Bono vacaciones",
        questions: [
          { name: "¿Qué es el bono de vacaciones?" },
          { name: "Requisitos bono vacaciones" },
          { name: "Recomendaciones bono vacaciones" }
        ]
      },
      {
        name: "Becas de estudio",
        questions: [
          { name: "¿En que consiste las becas de estudio?" },
          { name: "Requisitos beca de estudio" },
          { name: "Recomendaciones beca de estudio" }
        ]
      }
    ]
  },
  {
    name: "Vacaciones", 
    subcategories: [
      { 
        name: "Vacaciones progresivas",
        questions: [
          { name: "¿Dónde solicito mis vacaciones progresivas?" },
          { name: "Requisitos vacaciones progresivas" },
          { name: "Recomendaciones vacaciones progresivas" },
        ]
      },
      {
        name: "Saldo de vacaciones",
        questions: [
          { name: "Revisar saldo de vacaciones" },
          { name: "Recomendaciones saldo vacaciones" },
        ]
      }
    ]
  },
  {
    name: "Certificados", 
    subcategories: [
      { 
        name: "Certificado renta / antigüedad",
        questions: [
          { name: "Consultas sobre certificado renta / antigüedad" },
          { name: "Solicitar certificado renta / antigüedad" }
        ]
      },
      {
        name: "Certificado vacaciones progresivas",
        questions: [
          { name: "Consultas sobre certificado vacaciones progresivas" },
          { name: "Solicitar certificado vacaciones progresivas" }
        ]
      }
    ]
  },
  {
    name: "Contratos", 
    subcategories: [
      { 
        name: "Copia de contrato",
        questions: [
          { name: "Obtener copia de contrato" },
          { name: "Información copia contrato" }
        ]
      },
      {
        name: "Consultas de contrato",
        questions: [
          { name: "¿Dónde realizar consultas sobre mi contrato?" },
          { name: "Recomendaciones sobre contrato" }
        ]
      }
    ]
  }
]

Helpcenter::Category.delete_all
Helpcenter::Subcategory.delete_all
Helpcenter::Ticket.delete_all
Helpcenter::Question.delete_all

content = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec in lorem metus. Donec laoreet turpis eu ligula vulputate, non condimentum ex fringilla. Nullam sollicitudin mi vel libero finibus finibus. Nullam non metus ipsum. Aliquam consequat lacinia dui. Donec eleifend neque turpis, non tincidunt nibh pulvinar vel. Nunc et nisi et est bibendum pharetra. Nam a commodo magna. Fusce eget lobortis nulla. Nulla mollis risus tortor. Suspendisse potenti. Etiam bibendum, neque imperdiet suscipit faucibus, arcu lorem vulputate nisl, id pharetra ipsum purus et lorem. Suspendisse sagittis quam ultricies tortor dapibus volutpat. Fusce sit amet ipsum et nibh ultricies volutpat a eu ipsum. In malesuada id odio et efficitur. Praesent eget sapien magna."
profile = General::Profile.find_by(name: "General")

categories.each do |item|
  cat = Helpcenter::Category.create(name: item[:name], profile: profile)

  item[:subcategories].each do |subitem|
    subcat = Helpcenter::Subcategory.create(name: subitem[:name], category: cat)
    Role.create(name: cat.name, resource: cat) if Role.find_by(name: cat.name).nil?

    subitem[:questions].each do |q|
      puts("#{q}")
      question = Helpcenter::Question.create(name: q[:name], content: content, subcategory: subcat)
      puts("Pregunta #{question.id}")
    end
  end
end