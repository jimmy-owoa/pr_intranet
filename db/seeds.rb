puts("/////////// Inicio carga de datos de prueba ///////////")

# - - - - - - - - - - ROLES - - - - - - - - - -
puts("******* Creando Roles *******")
Role.find_or_create_by(name: "helpcenter", label_name: "Centro de ayuda")
Role.find_or_create_by(name: "admin", label_name: "Administrador")

# - - - - - - - - CIUDADES - - - - - - - - - -
General::Location.find_or_create_by(name: 'Antofagasta')
General::Location.find_or_create_by(name: 'Santiago')
General::Location.find_or_create_by(name: 'Copiapo')
General::Location.find_or_create_by(name: 'La Serena')
General::Location.find_or_create_by(name: 'Vina del Mar')
General::Location.find_or_create_by(name: 'Rancagua')
General::Location.find_or_create_by(name: 'Talca')
General::Location.find_or_create_by(name: 'Concepcion')
General::Location.find_or_create_by(name: 'Temuco')
General::Location.find_or_create_by(name: 'Puerto Montt')

# - - - - - - - - - - USUARIO ADMINISTRADOR - - - - - - - - - -
puts("******* Creando Usuario admin *******")
if General::User.find_by(email: "admin@exaconsultores.cl").nil?
  user_admin = General::User.create(
    name: "Admin Exa", 
    email: "admin@exaconsultores.cl", 
    password: "exaConsultores", 
    password_confirmation: "exaConsultores", 
    location_id: 2, 
    legal_number: "1", 
    legal_number_verification: "7"
  )

  user_admin.add_role :admin
end

puts("* * * * * * * Creando Usuarios * * * * * * *")
data_users = JSON.parse(File.read("public/demo_users.json"))

data_users.each do |user|
  ln_user = user["RUT"]
  email = user["Email"]
  name = user["Nombres"]
  last_name = user["Apellidos"]
  position_classification = user["clasificacion_puesto"]
  is_boss = user["es_jefe"] == "Si"
  rol = user["rol"]
  employee_classification = user["clasificacion_empleado"]
  date_entry = user["fecha_de_ingreso_grupo"]
  office_address = user["direccion_oficina"]
  office_commune = user["comuna_oficina"]
  office_city = user["ciudad_oficina"]
  office_region = user["region_oficina"]
  office_country = user["pais_oficina"]
  birthday = user["fecha_de_nacimento"]
  civil_status = user["estado_civil"]
  position = user["cargo"]
  annexed = user["anexo"]
  gender = user["sexo"]
  favorite_name = user["nombre_favorito"]
  company = Company::Company.where(name: user["empresa"]).first_or_create
  country = Location::Country.where(name: office_country).first_or_create
  region = Location::Region.where(name: office_region, country_id: country.id).first_or_create
  city = Location::City.where(name: office_city, region_id: region.id).first_or_create
  commune = Location::Commune.where(name: office_commune, city_id: city.id).first_or_create
  office = Company::Office.where(address: office_address, commune_id: commune.id).first_or_create

  user_data = General::User.find_by(email: email)

  if user_data.nil?
    General::User.create(
      legal_number: ln_user[0...-1], 
      legal_number_verification: ln_user[-1], 
      email: email, 
      name: name, 
      last_name: last_name, 
      position_classification: position_classification, 
      is_boss: is_boss, 
      rol: rol, 
      employee_classification: employee_classification, 
      date_entry: date_entry, 
      birthday: birthday, 
      civil_status: civil_status, 
      position: position, 
      annexed: annexed, 
      gender: gender, 
      favorite_name: favorite_name,
      company_id: company.id,
      office_id: office.id, 
      location_id: 2,
      password: "redexa2020", 
      password_confirmation: "redexa2020"
    )
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