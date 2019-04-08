def es_bisiesto?(year)
  year % 4 == 0 && year % 100 != 0 || year % 400 == 0
end
#term type
puts("******* Creando Term types *******")
General::TermType.find_or_create_by(name: 'category')
General::TermType.find_or_create_by(name: 'tag')
#terms
puts("******* Creando Terms *******")
General::Term.find_or_create_by(name: 'Banco', term_type_id: 1)
General::Term.find_or_create_by(name: 'Factoring', term_type_id: 1)
General::Term.find_or_create_by(name: 'Inversiones', term_type_id: 1)
General::Term.find_or_create_by(name: 'Vida', term_type_id: 1)
General::Term.find_or_create_by(name: 'Corredora de Seguros', term_type_id: 1)
General::Term.find_or_create_by(name: 'Travel', term_type_id: 1)
General::Term.find_or_create_by(name: 'Inmobiliaria', term_type_id: 1)
#roles
puts("******* Creando Roles *******")
Role.find_or_create_by(name: 'user')
Role.find_or_create_by(name: 'post_admin')
Role.find_or_create_by(name: 'super_admin')
Role.find_or_create_by(name: 'message_admin')
#location
puts("******* Creando Locations *******")
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
#users
puts("******* Creando Usuarios *******")
General::User.where(
  name:'Nombre',
  last_name: 'Apellido',
  annexed: '1029',
  password: 'security',
  password_confirmation: 'security',
  email: 'admin@security.cl',
  birthday: Date.today,
  location_id: 2
).first_or_create
General::User.where(
  name:'Nombre 2',
  last_name: 'Apellido 2',
  annexed: '1928',
  password: 'security',
  password_confirmation: 'security',
  email: 'user@security.cl',
  birthday: Date.today-1,
  location_id: 2
).first_or_create
General::User.where(
  name:'Persona 3',
  last_name: 'a cargo de',
  annexed: '11020',
  password: 'security',  
  password_confirmation: 'security',
  email: 'a-cargo-de@security.cl',
  birthday: Date.today-2,
  location_id: 2
).first_or_create
General::User.where(
  name:'Persona 4',
  last_name: 'rama',
  annexed: '22212',
  password: 'security',
  password_confirmation: 'security',
  email: 'otro-a-cargode@security.cl',
  birthday: Date.today-2,
  location_id: 2
).first_or_create
#users / user_admin see admin screen and user see welcome screen
user_admin = General::User.first
user = General::User.second
#add roles to user - 
user_admin.add_role :super_admin
user.add_role :user
#economic indicators
General::EconomicIndicatorType.where(name: 'dolar', symbol: 'US$').first_or_create #1
General::EconomicIndicatorType.where(name: 'euro', symbol: '€').first_or_create #2
General::EconomicIndicatorType.where(name: 'uf', symbol:'UF' ).first_or_create #3
General::EconomicIndicatorType.where(name: 'utm', symbol: 'UTM').first_or_create #4
General::EconomicIndicatorType.where(name: 'ipc', symbol: 'IPC').first_or_create #5
General::EconomicIndicatorType.where(name: 'ipsa', symbol: 'SPCLXIPSA').first_or_create #6
#post
News::Post.where(
  title: '¡Gravísimo! Facebook traficó con tus mensajes privados de forma grotesca con otras compañías', 
  slug: 'Slug', 
  content: '¡Netflix, Spotify y varias firmas involucradas en serio caso! Facebook superándose a sí mismo, una vez más.', visibility: "Público", 
  post_class: "tipo", 
  user_id: 1,
  format: 0
).first_or_create
News::Post.where(
  title: 'Observatorio de Rayos Gamma más potente del mundo se instalará en Chile', 
  slug: 'Slug', 
  content: 'En el proyecto participarán diversas instituciones nacionales e internacionales y permitirá la instalación de este potente observatorio de Rayos Gamma.', 
  visibility: "Público", 
  post_class: "tipo", 
  user_id: 1,
  format: 0
).first_or_create
News::Post.where(
  title: 'Elon Musk y The Boring Company muestran su sistema de túneles en acción', 
  slug: 'Slug', 
  content: 'The Boring Company abrió su primera línea de transporte para que los mortales conozcamos el futuro del desplazamiento.',visibility: "Público", 
  post_class: "tipo", 
  user_id: 1,
  format: 0
).first_or_create
#esto no funciona, manda error en el main_image_id( que no lo agregué en el create del post)

#product and image
Marketplace::Product.where(
  name: 'Auto',
  description: 'Auto amarillo',
  product_type: 'Autos',
  price: 5000000.0,
  email: "ventadeauto@gmail.com",
  phone: 12093848,
  location: "Santiago",
  expiration: 30,
  approved: true,
  user_id: 1
).first_or_create

#birth
Employee::Birth.find_or_create_by(full_name_mother: "mamá nacido",
  full_name_father: "papá nacido",
  child_name: "nombre nacido",
  child_lastname: "apellido nacido",
  approved: true,
  gender: true,
  birthday: Date.today
)

#surveys
Survey::Survey.find_or_create_by(name: 'Encuesta de las ciudades de Chile')
Survey::Question.find_or_create_by( title: "¿Cual es la ciudad más linda de Chile?", description: "Encuesta para saber cual es la ciudad favorita de los usuarios.", question_type: "Simple", survey_id: 1)
Survey::Option.find_or_create_by(title: "Arica", default: true, placeholder: "", question_id: 1)
Survey::Option.find_or_create_by(title: "Calama", default: false, placeholder: "", question_id: 1)
Survey::Option.find_or_create_by(title: "Coquimbo", default: false, placeholder: "", question_id: 1)
Survey::Option.find_or_create_by(title: "Puerto Montt", default: false, placeholder: "", question_id: 1)
Survey::Option.find_or_create_by(title: "Punta Arenas", default: false, placeholder: "", question_id: 1)
#cities
 (1..10).each do |city|
  General::WeatherInformation.find_or_create_by(
    location_id: city, 
    date: Date.today,
    current_temp: "21",
    condition: "Partly cloudy",
    icon: "//cdn.apixu.com/weather/64x64/day/116.png",
    max_temp: "27.4",
    min_temp: "12.8",
  )
end

#############menú nuevo#############
# ELIMINA MENUS Y SU CONTÉO DE ID NECESARIO PARA LOS PARENT_ID / revisar
ActiveRecord::Base.connection.execute('TRUNCATE TABLE general_menus;') 

#->Vacaciones
General::Menu.find_or_create_by(
  title: "Vacaciones",
  description: "Vacaciones Security",
  css_class: "#000000",
  code: 1231,
  link: "vacaciones",
  priority: nil,
  parent_id: nil
)
vacation = General::Menu.find_by_title('Vacaciones')
General::Menu.find_or_create_by(
  title: "Solicitudes",
  description: "Solicitudes",
  css_class: "#db9398",
  code: 1232,
  link: "solicitudes",
  priority: nil,
  parent_id: vacation.id
)
General::Menu.find_or_create_by(
  title: "Aprobación",
  description: "Aprobación",
  css_class: "#db9398",
  code: 1233,
  link: "aprobacion",
  priority: nil,
  parent_id: vacation.id
)
General::Menu.find_or_create_by(
  title: "Vacaciones progresivas",
  description: "Vacaciones progresivas",
  css_class: "#db3562",
  code: 1234,
  link: "vacaciones-progresivas",
  priority: nil,
  parent_id: vacation.id
)
#->Permisos
General::Menu.find_or_create_by(
  title: "Permisos",
  description: "Permisos",
  css_class: "#243in0",
  code: 121352,
  link: "",
  priority: nil,
  parent_id: nil
)
permission = General::Menu.find_by_title('Permisos')
# 24 Horas para algo importante
General::Menu.find_or_create_by(
  title: "24 Horas para algo importante",
  description: "24 Horas para algo importante",
  css_class: "#3nnd99",
  code: 11236,
  link: "algo-importante",
  priority: nil,
  parent_id: permission.id
)
# Post Natal Paterno
General::Menu.find_or_create_by(
  title: "Post Natal Paterno",
  description: "Post Natal Paterno",
  css_class: "#346kg9",
  code: 91233,
  link: "post-natal-paterno",
  priority: nil,
  parent_id: permission.id
)
# Matrimonio
General::Menu.find_or_create_by(
  title: "Matrimonio",
  description: "Matrimonio",
  css_class: "#93899h",
  code: 71232,
  link: "matrimonio",
  priority: nil,
  parent_id: permission.id
)
# Unión Civil
General::Menu.find_or_create_by(
  title: "Unión Civil",
  description: "Unión Civil",
  css_class: "#64334f",
  code: 41231,
  link: "union-civil",
  priority: nil,
  parent_id: permission.id
)
# Fallecimiento 
General::Menu.find_or_create_by(
  title: "Fallecimiento",
  description: "Fallecimiento",
  css_class: "#04jdj9",
  code: 41231,
  link: "fallecimiento",
  priority: nil,
  parent_id: permission.id
)
# Examen de Grado
General::Menu.find_or_create_by(
  title: "Examen de Grado",
  description: "Examen de Grado",
  css_class: "#04jdj9",
  code: 43990,
  link: "examen-de-grado",
  priority: nil,
  parent_id: permission.id
)
# Exámenes Preventivos 
General::Menu.find_or_create_by(
  title: "Exámenes Preventivos",
  description: "Exámenes Preventivos",
  css_class: "#983839",
  code: 43982,
  link: "examenes-preventivos",
  priority: nil,
  parent_id: permission.id
)
# Día Libre para cambio de casa 
General::Menu.find_or_create_by(
  title: "Día Libre para cambio de casa",
  description: "Día Libre para cambio de casa",
  css_class: "#7889s0",
  code: 41932,
  link: "dia-libre-cambio-casa",
  priority: nil,
  parent_id: permission.id
)
#->Tarjeta de trabajo bien hecho
General::Menu.find_or_create_by(
  title: "Tarjeta de trabajo bien hecho",
  description: "Tarjeta de trabajo bien hecho",
  css_class: "#c5590k",
  code: 45235,
  link: "",
  priority: nil,
  parent_id: nil
)
work_card = General::Menu.find_by_title('Tarjeta de trabajo bien hecho')
#Ingresar tarjeta
General::Menu.find_or_create_by(
  title: "Ingresar tarjeta",
  description: "Ingresar tarjeta",
  css_class: "#9883hb",
  code: 12336,
  link: "ingreso-tarjeta",
  priority: nil,
  parent_id: work_card.id
)
#Mis tarjetas
General::Menu.find_or_create_by(
  title: "Mis tarjetas",
  description: "Mis tarjetas",
  css_class: "#989390",
  code: 48336,
  link: "mis-tarjetas",
  priority: nil,
  parent_id: work_card.id
)
#->Selección	
General::Menu.find_or_create_by(
  title: "Selección",
  description: "Selección",
  css_class: "#m28390",
  code: 35239,
  link: "",
  priority: nil,
  parent_id: nil
  )
selection = General::Menu.find_by_title('Selección')
#Ingreso solicitudes
General::Menu.find_or_create_by(
  title: "Ingreso solicitudes",
  description: "Ingreso solicitudes",
  css_class: "#n89279",
  code: 91232,
  link: "ingreso-solicitudes",
  priority: nil,
  parent_id: selection.id
)
#Seguimiento
General::Menu.find_or_create_by(
  title: "Seguimiento",
  description: "Seguimiento",
  css_class: "#g77900",
  code: 91232,
  link: "seguimiento",
  priority: nil,
  parent_id: selection.id
)
#Mis solicitudes
General::Menu.find_or_create_by(
  title: "Mis solicitudes",
  description: "Mis solicitudes",
  css_class: "#yu8999",
  code: 98282,
  link: "mis-solicitudes",
  priority: nil,
  parent_id: selection.id
)
#Evaluación de solicitudes
General::Menu.find_or_create_by(
  title: "Evaluación de solicitudes",
  description: "Evaluación de solicitudes",
  css_class: "#b77890",
  code: 92242,
  link: "evaluacion-solicitudes",
  priority: nil,
  parent_id: selection.id
)
#->Desempeño y Desarrollo	
General::Menu.find_or_create_by(
  title: "Desempeño y Desarrollo",
  description: "Desempeño y Desarrollo",
  css_class: "#968390",
  code: 75232,
  link: "",
  priority: nil,
  parent_id: nil
)
development = General::Menu.find_by_title('Desempeño y Desarrollo')
#Plan de desarrollo profesional
General::Menu.find_or_create_by(
  title: "Plan de desarrollo profesional",
  description: "Plan de desarrollo profesional",
  css_class: "#v77890",
  code: 87736,
  link: "plan-desarrollo-profesional",
  priority: nil,
  parent_id: development.id
)
#Talento
General::Menu.find_or_create_by(
  title: "Talento",
  description: "Talento",
  css_class: "#d77780",
  code: 82799,
  link: "talento",
  priority: nil,
  parent_id: development.id
)
#(Tal cual está ahora en exa)
# General::Menu.find_or_create_by(
#   title: "Talento",
#   description: "Talento",
#   css_class: "#d77780",
#   code: 82799,
#   link: "talento",
#   priority: nil,
#   parent_id: development.id
# )
	
#Capacitemonos	
General::Menu.find_or_create_by(
  title: "Capacitemonos",
  description: "Capacitemonos",
  css_class: "#768393",
  code: 55235,
  link: "",
  priority: nil,
  parent_id: nil
)
capacitation = General::Menu.find_by_title('Capacitemonos')
#Capacitación Corporativa
General::Menu.find_or_create_by(
  title: "Capacitación Corporativa",
  description: "Capacitación Corporativa",
  css_class: "#647720",
  code: 52599,
  link: "capacitacion-corporativa",
  priority: nil,
  parent_id: capacitation.id
)
#Capacitación Funcional
General::Menu.find_or_create_by(
  title: "Capacitación Funcional",
  description: "Capacitación Funcional",
  css_class: "#641160",
  code: 52592,
  link: "capacitacion-funcional",
  priority: nil,
  parent_id: capacitation.id
)
#Programa excelencia
General::Menu.find_or_create_by(
  title: "Programa excelencia",
  description: "Programa excelencia",
  css_class: "#649370",
  code: 52340,
  link: "programa-excelencia",
  priority: nil,
  parent_id: capacitation.id
)
#Material de Capacitación
General::Menu.find_or_create_by(
  title: "Material de Capacitación",
  description: "Material de Capacitación",
  css_class: "#379908",
  code: 52239,
  link: "material-capacitacion",
  priority: nil,
  parent_id: capacitation.id
)
#Historial de Capacitación
General::Menu.find_or_create_by(
  title: "Historial de Capacitación",
  description: "Historial de Capacitación",
  css_class: "#379100",
  code: 52189,
  link: "historial-capacitacion",
  priority: nil,
  parent_id: capacitation.id
)
#->Remuneraciones	
General::Menu.find_or_create_by(
  title: "Remuneraciones",
  description: "Remuneraciones",
  css_class: "#366678",
  code: 65235,
  link: "",
  priority: nil,
  parent_id: nil
)
remuneration = General::Menu.find_by_title('Remuneraciones')
#Liquidaciones
General::Menu.find_or_create_by(
  title: "Liquidaciones",
  description: "Liquidaciones",
  css_class: "#299900",
  code: 67789,
  link: "liquidaciones",
  priority: nil,
  parent_id: remuneration.id
)
#Anticipos
General::Menu.find_or_create_by(
  title: "Anticipos",
  description: "Anticipos",
  css_class: "#23929",
  code: 67199,
  link: "anticipos",
  priority: nil,
  parent_id: remuneration.id
)
#APV
General::Menu.find_or_create_by(
  title: "APV",
  description: "APV",
  css_class: "#23121",
  code: 61149,
  link: "apv",
  priority: nil,
  parent_id: remuneration.id
)
#Certificados	
General::Menu.find_or_create_by(
  title: "Certificados",
  description: "Certificados",
  css_class: "#88999",
  code: 78829,
  link: "",
  priority: nil,
  parent_id: nil
)
certification = General::Menu.find_by_title('Certificados')
#Antigüedad
General::Menu.find_or_create_by(
  title: "Antigüedad",
  description: "Antigüedad",
  css_class: "#29929",
  code: 78829,
  link: "antiguedad",
  priority: nil,
  parent_id: certification.id
)
#Renta
General::Menu.find_or_create_by(
  title: "Renta",
  description: "Renta",
  css_class: "#22929",
  code: 78195,
  link: "renta",
  priority: nil,
  parent_id: certification.id
)
################################################ TERMINO EN LINEA ################################################
#->Noticias
General::Menu.find_or_create_by(
  title: "Noticias",
  description: "Noticias new menu",
  css_class: "#b13362",
  code: 1235,
  link: "",
  priority: nil,
  parent_id: nil
)
# General::Menu.create(
#   title: "Noticias",
#   description: "Noticias new menu",
#   css_class: "#b13362",
#   code: 1235,
#   link: "",
#   priority: nil,
#   parent_id: nil
# )
post = General::Menu.find_by_description('Noticias new menu')
#Corporativas
General::Menu.find_or_create_by(
  title: "Corporativas",
  description: "corporativas",
  css_class: "#b13362",
  code: 1236,
  link: "corporativas",
  priority: nil,
  parent_id: post.id
)
#Miscelaneos
General::Menu.find_or_create_by(
  title: "Miscelaneos",
  description: "Miscelaneos",
  css_class: "#b10312",
  code: 1237,
  link: "miscelaneos",
  priority: nil,
  parent_id: post.id
)
#Conociéndonos
General::Menu.find_or_create_by(
  title: "Conociéndonos",
  description: "Conociéndonos",
  css_class: "#a15293",
  code: 1238,
  link: "conociendonos",
  priority: nil,
  parent_id: post.id
)
#->Políticas	
General::Menu.find_or_create_by(
  title: "Políticas",
  description: "Políticas",
  css_class: "#bp1332",
  code: 17235,
  link: "",
  priority: nil,
  parent_id: nil
)
politic = General::Menu.find_by_title('Políticas')
#Corporativas
General::Menu.find_or_create_by(
  title: "Corporativas",
  description: "Corporativas",
  css_class: "#65293",
  code: 44238,
  link: "corporativas",
  priority: nil,
  parent_id: politic.id
)
#Políticas Factoring Security
General::Menu.find_or_create_by(
  title: "Políticas Factoring Security",
  description: "Políticas Factoring Security",
  css_class: "#93293",
  code: 41258,
  link: "politicas-factoring-security",
  priority: nil,
  parent_id: politic.id
)
#Políticas Inversiones Security
General::Menu.find_or_create_by(
  title: "Políticas Inversiones Security",
  description: "Políticas Inversiones Security",
  css_class: "#92213",
  code: 11358,
  link: "politicas-inversiones-security",
  priority: nil,
  parent_id: politic.id
)
#Políticas Corredora Security
General::Menu.find_or_create_by(
  title: "Políticas Corredora Security",
  description: "Políticas Corredora Security",
  css_class: "#52413",
  code: 71552,
  link: "politicas-corredora-security",
  priority: nil,
  parent_id: politic.id
)
#Políticas Travel Security
General::Menu.find_or_create_by(
  title: "Políticas Travel Security",
  description: "Políticas Travel Security",
  css_class: "#59213",
  code: 79551,
  link: "politicas-travel-security",
  priority: nil,
  parent_id: politic.id
)
#Políticas Banco Security
General::Menu.find_or_create_by(
  title: "Políticas Banco Security",
  description: "Políticas Banco Security",
  css_class: "#52233",
  code: 71541,
  link: "politicas-banco-security",
  priority: nil,
  parent_id: politic.id
)
#Políticas Vida Security
General::Menu.find_or_create_by(
  title: "Políticas Vida Security",
  description: "Políticas Vida Security",
  css_class: "#58211",
  code: 72549,
  link: "politicas-vida-security",
  priority: nil,
  parent_id: politic.id
)
#Políticas Mandatos Security
General::Menu.find_or_create_by(
  title: "Políticas Mandatos Security",
  description: "Políticas Mandatos Security",
  css_class: "#58019",
  code: 74540,
  link: "politicas-mandatos-security",
  priority: nil,
  parent_id: politic.id
)
#Políticas Grupo Security
General::Menu.find_or_create_by(
  title: "Políticas Grupo Security",
  description: "Políticas Grupo Security",
  css_class: "#52419",
  code: 71500,
  link: "politicas-grupo-security",
  priority: nil,
  parent_id: politic.id
)
#Políticas Hipotecaria 
General::Menu.find_or_create_by(
  title: "Políticas Hipotecaria",
  description: "Políticas Hipotecaria",
  css_class: "#56411",
  code: 74501,
  link: "politicas-hipotecarias-security",
  priority: nil,
  parent_id: politic.id
)
#->Guardianes del Security
General::Menu.find_or_create_by(
  title: "Guardianes del Security",
  description: "Guardianes del Security",
  css_class: "#p19362",
  code: 91225,
  link: "",
  priority: nil,
  parent_id: nil
)
guardian = General::Menu.find_by_title('Guardianes del Security')
#Información importante 
General::Menu.find_or_create_by(
  title: "Información importante",
  description: "Información importante",
  css_class: "#96312",
  code: 96101,
  link: "informacion-importante",
  priority: nil,
  parent_id: guardian.id
)
#Tutoriales 
General::Menu.find_or_create_by(
  title: "Tutoriales",
  description: "Tutoriales",
  css_class: "#93382",
  code: 98801,
  link: "tutoriales",
  priority: nil,
  parent_id: guardian.id
)
#Cliente Integral
General::Menu.find_or_create_by(
  title: "Cliente Integral",
  description: "Cliente Integral",
  css_class: "#139362",
  code: 99923,
  link: "",
  priority: nil,
  parent_id: nil
)
integral = General::Menu.find_by_title('Cliente Integral')
#Refiere aquí
General::Menu.find_or_create_by(
  title: "Refiere aquí",
  description: "Refiere aquí",
  css_class: "#92352",
  code: 98304,
  link: "refiere-aqui",
  priority: nil,
  parent_id: integral.id
)
#Acceso al sitio 
General::Menu.find_or_create_by(
  title: "Acceso al sitio ",
  description: "Acceso al sitio ",
  css_class: "#92654",
  code: 93303,
  link: "acceso-sitio",
  priority: nil,
  parent_id: integral.id
)
#->Reconociendo	
General::Menu.find_or_create_by(
  title: "Reconociendo",
  description: "Reconociendo",
  css_class: "#00034",
  code: 78888,
  link: "",
  priority: nil,
  parent_id: nil
)
recognize = General::Menu.find_by_title('Reconociendo')
#Tarjeta de trabajo bien hecho
General::Menu.find_or_create_by(
  title: "Tarjeta de trabajo bien hecho ",
  description: "Tarjeta de trabajo bien hecho ",
  css_class: "#002838",
  code: 763403,
  link: "tarjeta-trabajo-bien-hecho",
  priority: nil,
  parent_id: recognize.id
)
#Premio Espíritu
General::Menu.find_or_create_by(
  title: "Premio Espíritu",
  description: "Premio Espíritu",
  css_class: "#006868",
  code: 764404,
  link: "premio-espiritu",
  priority: nil,
  parent_id: recognize.id
)
#Premio Integración
General::Menu.find_or_create_by(
  title: "Premio Integración",
  description: "Premio Integración",
  css_class: "#001811",
  code: 764111,
  link: "premio-integracion",
  priority: nil,
  parent_id: recognize.id
)
#Premio Calidad de servicio
General::Menu.find_or_create_by(
  title: "Premio Calidad de servicio",
  description: "Premio Calidad de servicio",
  css_class: "#002289",
  code: 764998,
  link: "premio-calidad-servicio",
  priority: nil,
  parent_id: recognize.id
)
#Grupo Best
General::Menu.find_or_create_by(
  title: "Grupo Best",
  description: "Grupo Best",
  css_class: "#007778",
  code: 79003,
  link: "grupo-best",
  priority: nil,
  parent_id: recognize.id
)
#->Oportunidades Security	
General::Menu.find_or_create_by(
  title: "Oportunidades Security",
  description: "Oportunidades Security",
  css_class: "#34444",
  code: 38443,
  link: "",
  priority: nil,
  parent_id: nil
)
opportunity = General::Menu.find_by_title('Oportunidades Security')
#Cargos disponibles
General::Menu.find_or_create_by(
  title: "Cargos disponibles",
  description: "Cargos disponibles",
  css_class: "#38899",
  code: 39999,
  link: "cargo-disponible",
  priority: nil,
  parent_id: opportunity.id
)
#Referidos
General::Menu.find_or_create_by(
  title: "Referidos",
  description: "Referidos",
  css_class: "#311222",
  code: 32990,
  link: "referidos",
  priority: nil,
  parent_id: opportunity.id
)
#->Programa Previsional	
General::Menu.find_or_create_by(
  title: "Programa Previsional",
  description: "Programa Previsional",
  css_class: "#24224",
  code: 28223,
  link: "",
  priority: nil,
  parent_id: nil
)
program = General::Menu.find_by_title('Programa Previsional')
#Solicita tu asesoría
General::Menu.find_or_create_by(
  title: "Solicita tu asesoría",
  description: "Solicita tu asesoría",
  css_class: "#21998",
  code: 22765,
  link: "solicita-asesoria",
  priority: nil,
  parent_id: program.id
)
#Información
General::Menu.find_or_create_by(
  title: "Información",
  description: "Información",
  css_class: "#29938",
  code: 29769,
  link: "informacion",
  priority: nil,
  parent_id: program.id
)
#->Celebremos	
General::Menu.find_or_create_by(
  title: "Celebremos",
  description: "Celebremos",
  css_class: "#64220",
  code: 68002,
  link: "",
  priority: nil,
  parent_id: nil
)
celebrate = General::Menu.find_by_title('Celebremos')
#Nacimientos
General::Menu.find_or_create_by(
  title: "Nacimientos",
  description: "Nacimientos",
  css_class: "#67778",
  code: 63520,
  link: "celebremos-nacimientos",
  priority: nil,
  parent_id: celebrate.id
)
#Cumpleaños
General::Menu.find_or_create_by(
  title: "Cumpleaños",
  description: "Cumpleaños",
  css_class: "#67338",
  code: 63424,
  link: "celebremos-cumpleaños",
  priority: nil,
  parent_id: celebrate.id
)
#Bienvenidos
General::Menu.find_or_create_by(
  title: "Bienvenidos",
  description: "Bienvenidos",
  css_class: "#62278",
  code: 63903,
  link: "celebremos-bienvenidos",
  priority: nil,
  parent_id: celebrate.id
)
#->Ayuda a la comunidad
General::Menu.find_or_create_by(
  title: "Ayuda a la comunidad",
  description: "Ayuda a la comunidad",
  css_class: "#54550",
  code: 55002,
  link: "",
  priority: nil,
  parent_id: nil
)
community = General::Menu.find_by_title('Ayuda a la comunidad')
#Fundación Las Rosas
General::Menu.find_or_create_by(
  title: "Fundación Las Rosas",
  description: "Fundación Las Rosas",
  css_class: "#55258",
  code: 55999,
  link: "fundacion-las-rosas",
  priority: nil,
  parent_id: community.id
)
#Fundación Mi Parque
General::Menu.find_or_create_by(
  title: "Fundación Mi Parque",
  description: "Fundación Mi Parque",
  css_class: "#55599",
  code: 55876,
  link: "fundacion-mi-parque",
  priority: nil,
  parent_id: community.id
)
#->Puertas abiertas
General::Menu.find_or_create_by(
  title: "Puertas abiertas",
  description: "Puertas abiertas",
  css_class: "#89999",
  code: 87764,
  link: "",
  priority: nil,
  parent_id: nil
)
door_open = General::Menu.find_by_title('Puertas abiertas')
#Solicitar Puertas Abiertas
General::Menu.find_or_create_by(
  title: "Solicitar Puertas Abiertas",
  description: "Solicitar Puertas Abiertas",
  css_class: "#80003",
  code: 82330,
  link: "solicitar-puertas-abiertas",
  priority: nil,
  parent_id: door_open.id
)
#Descripción
General::Menu.find_or_create_by(
  title: "Descripción",
  description: "Descripción",
  css_class: "#82939",
  code: 83648,
  link: "descripcion",
  priority: nil,
  parent_id: door_open.id
)
#->Cultura Corporativa
General::Menu.find_or_create_by(
  title: "Cultura Corporativa",
  description: "Cultura Corporativa",
  css_class: "#65677",
  code: 63200,
  link: "",
  priority: nil,
  parent_id: nil
)
sporty = General::Menu.find_by_title('Cultura Corporativa')

#Tiempo libre	
General::Menu.create(
  title: "Tiempo libre",
  description: "Tiempo libre",
  css_class: "#11110",
  code: 11145,
  link: "",
  priority: nil,
  parent_id: nil
)
free_time = General::Menu.find_by_title('Tiempo libre')
#Avisos clasificados
General::Menu.find_or_create_by(
  title: "Avisos clasificados",
  description: "Avisos clasificados",
  css_class: "#11100",
  code: 11399,
  link: "avisos-clasificados",
  priority: nil,
  parent_id: free_time.id
)
#Biblioteca y ludoteca
General::Menu.find_or_create_by(
  title: "Biblioteca y ludoteca",
  description: "Biblioteca y ludoteca",
  css_class: "#12000",
  code: 14957,
  link: "biblioteca-ludoteca",
  priority: nil,
  parent_id: free_time.id
)
#Jugar y aprender
General::Menu.find_or_create_by(
  title: "Jugar y aprender",
  description: "Jugar y aprender",
  css_class: "#19300",
  code: 18355,
  link: "jugar-y-aprender",
  priority: nil,
  parent_id: free_time.id
)
#Ser +
General::Menu.find_or_create_by(
  title: "Ser +",
  description: "Ser +",
  css_class: "#12333",
  code: 13678,
  link: "ser-mas",
  priority: nil,
  parent_id: free_time.id
)
#Concursos de cuentos
General::Menu.find_or_create_by(
  title: "Concursos de cuentos",
  description: "Concursos de cuentos",
  css_class: "#14559",
  code: 13659,
  link: "concurso-cuentos",
  priority: nil,
  parent_id: free_time.id
)
#Concursos de fotografía
General::Menu.find_or_create_by(
  title: "Concursos de fotografía",
  description: "Concursos de fotografía",
  css_class: "#15277",
  code: 15289,
  link: "concurso-fotografia",
  priority: nil,
  parent_id: free_time.id
)
#Concurso de pintura
General::Menu.find_or_create_by(
  title: "Concurso de pintura",
  description: "Concurso de pintura",
  css_class: "#13447",
  code: 13553,
  link: "concurso-pintura",
  priority: nil,
  parent_id: free_time.id
)
#Concuros Papá Espíritu Security
General::Menu.find_or_create_by(
  title: "Concuros Papá Espíritu Security",
  description: "Concuros Papá Espíritu Security",
  css_class: "#12222",
  code: 19920,
  link: "concurso-papa-espiritu-security",
  priority: nil,
  parent_id: free_time.id
)
################################################ TÉRMINO INFORMADOS

#->Mis beneficios
General::Menu.find_or_create_by(
  title: "Bonos",
  description: "Bonos",
  css_class: "#y32233",
  code: 12399,
  link: "",
  priority: nil,
  parent_id: nil
)
bonus = General::Menu.find_by_title('Bonos')
General::Menu.find_or_create_by(
  title: "Vacaciones",
  description: "Vacaciones",
  css_class: "#y32571",
  code: 12498,
  link: "bono-vacaciones",
  priority: nil,
  parent_id: bonus.id
)
General::Menu.find_or_create_by(
  title: "Bono Auxiliar de Párvulo Materno",
  description: "Bono Auxiliar de Párvulo Materno",
  css_class: "#y32571",
  code: 1239,
  link: "bono-auxiliar-parvulo-materno",
  priority: nil,
  parent_id: bonus.id
)
General::Menu.find_or_create_by(
  title: "Bono Auxiliar de Párvulo Paterno",
  description: "Bono Auxiliar de Párvulo Paterno",
  css_class: "#366s12",
  code: 1240,
  link: "bono-auxiliar-parvulo-paterno",
  priority: nil,
  parent_id: bonus.id
)
General::Menu.find_or_create_by(
  title: "Sala Cuna",
  description: "Sala Cuna",
  css_class: "#334d12",
  code: 12400,
  link: "bono-sala-cuna",
  priority: nil,
  parent_id: bonus.id
)
General::Menu.find_or_create_by(
  title: "Jardín Infantil",
  description: "Jardín Infantil",
  css_class: "#124dd2",
  code: 12403,
  link: "bono-jardin-infantil",
  priority: nil,
  parent_id: bonus.id
)
General::Menu.find_or_create_by(
  title: "Nacimiento",
  description: "Nacimiento",
  css_class: "#2930dj",
  code: 12407,
  link: "bono-nacimiento",
  priority: nil,
  parent_id: bonus.id
)
General::Menu.find_or_create_by(
  title: "Matrimonio",
  description: "Matrimonio",
  css_class: "#b2310o",
  code: 1242,
  link: "bono-de-matrimonio",
  priority: nil,
  parent_id: bonus.id
)
General::Menu.find_or_create_by(
  title: "Unión Civil",
  description: "Unión Civil",
  css_class: "#34949j",
  code: 12422,
  link: "bono-union-civil",
  priority: nil,
  parent_id: bonus.id
)
General::Menu.find_or_create_by(
  title: "Fallecimiento",
  description: "Fallecimiento",
  css_class: "#109220",
  code: 1241,
  link: "bono-fallecimiento",
  priority: nil,
  parent_id: bonus.id
)
General::Menu.find_or_create_by(
  title: "Escolaridad",
  description: "Escolaridad",
  css_class: "#a81123",
  code: 12423,
  link: "bono-escolaridad",
  priority: nil,
  parent_id: bonus.id
)
General::Menu.find_or_create_by(
  title: "Gestión Empresa",
  description: "Gestión Empresa",
  css_class: "#a81234",
  code: 12483,
  link: "bono-gestion-empresa",
  priority: nil,
  parent_id: bonus.id
)
General::Menu.find_or_create_by(
  title: "Ahorro Jubilación 1+1",
  description: "Ahorro Jubilación 1+1",
  css_class: "#a89i89",
  code: 12463,
  link: "bono-ahorro-jubilacion",
  priority: nil,
  parent_id: bonus.id
)
General::Menu.find_or_create_by(
  title: "Aguinaldo Fiestas Patrias",
  description: "Aguinaldo Fiestas Patrias",
  css_class: "#a12203",
  code: 1244,
  link: "aguinaldo-fiestas-patrias",
  priority: nil,
  parent_id: bonus.id
)
#->Créditos y Subsidios	
General::Menu.find_or_create_by(
  title: "Créditos y Subsidios",
  description: "Créditos y Subsidios",
  css_class: "#u88899",
  code: 49900,
  link: "",
  priority: nil,
  parent_id: nil
)
credit = General::Menu.find_by_title('Créditos y Subsidios')
#Créditos Banca Empleados
General::Menu.find_or_create_by(
  title: "Créditos Banca Empleados",
  description: "Créditos Banca Empleados",
  css_class: "#r8899",
  code: 66679,
  link: "creditos-banca-empleados",
  priority: nil,
  parent_id: credit.id
)
#Subsidio Habitacional
General::Menu.find_or_create_by(
  title: "Subsidio Habitacional",
  description: "Subsidio Habitacional",
  css_class: "#w2222",
  code: 99920,
  link: "subsidio-habitacional",
  priority: nil,
  parent_id: credit.id
)
#Seguros
General::Menu.find_or_create_by(
  title: "Seguros",
  description: "Seguros",
  css_class: "#o0293",
  code: 24849,
  link: "",
  priority: nil,
  parent_id: nil
)
secure = General::Menu.find_by_title('Seguros')
#Seguro de Salud y Catastrófico
General::Menu.find_or_create_by(
  title: "Seguro de Salud y Catastrófico",
  description: "Seguro de Salud y Catastrófico",
  css_class: "#53444",
  code: 48489,
  link: "seguro-salud-catastrofico",
  priority: nil,
  parent_id: secure.id
)
#Seguro de vida 
General::Menu.find_or_create_by(
  title: "Seguro de vida",
  description: "Seguro de vida",
  css_class: "#59990",
  code: 45323,
  link: "seguro-de-vida",
  priority: nil,
  parent_id: secure.id
)
#Seguro Dental
General::Menu.find_or_create_by(
  title: "Seguro Dental",
  description: "Seguro Dental",
  css_class: "#40110",
  code: 41300,
  link: "seguro-dental",
  priority: nil,
  parent_id: secure.id
)
#Seguro Vida 24 Rentas
General::Menu.find_or_create_by(
  title: "Seguro Vida 24 Rentas",
  description: "Seguro Vida 24 Rentas",
  css_class: "#42199",
  code: 42390,
  link: "seguro-vida-24-rentas",
  priority: nil,
  parent_id: secure.id
)
#->Becas
General::Menu.find_or_create_by(
  title: "Becas",
  description: "Becas",
  css_class: "#33330",
  code: 39490,
  link: "",
  priority: nil,
  parent_id: nil
)
scholarship = General::Menu.find_by_title('Becas')
#Becas de estudio hijos
General::Menu.find_or_create_by(
  title: "Becas de estudio hijos",
  description: "Becas de estudio hijos",
  css_class: "#55543",
  code: 55322,
  link: "becas-estudio-hijos",
  priority: nil,
  parent_id: scholarship.id
)
#Becas de estudio para empleados
General::Menu.find_or_create_by(
  title: "Becas de estudio para empleados",
  description: "Becas de estudio para empleados",
  css_class: "#53321",
  code: 55322,
  link: "becas-estudio-empleados",
  priority: nil,
  parent_id: scholarship.id
)
#->Tiempo Libre	
General::Menu.create(
  title: "Tiempo Libre",
  description: "Beneficios Tiempo Libre",
  css_class: "#o0293",
  code: 24849,
  link: "",
  priority: nil,
  parent_id: nil
)
b_free_time = General::Menu.find_by_description('Beneficios Tiempo Libre')
#Jornada reducida (viernes)
General::Menu.find_or_create_by(
  title: "Jornada reducida (viernes)",
  description: "Jornada reducida (viernes)",
  css_class: "#19384",
  code: 12900,
  link: "jornada-reducida",
  priority: nil,
  parent_id: b_free_time.id
)
#24 hrs para algo importante
General::Menu.find_or_create_by(
  title: "24 hrs para algo importante",
  description: "24 hrs para algo importante",
  css_class: "#18299",
  code: 17268,
  link: "24-horas-algo-importante",
  priority: nil,
  parent_id: b_free_time.id
)
#Vacaciones temporada baja
General::Menu.find_or_create_by(
  title: "Vacaciones temporada baja",
  description: "Vacaciones temporada baja",
  css_class: "#17283",
  code: 17253,
  link: "vacaciones-temporada-baja",
  priority: nil,
  parent_id: b_free_time.id
)
#Día Libre para cambio de casa 
General::Menu.find_or_create_by(
  title: "Día Libre para cambio de casa",
  description: "Día Libre para cambio de casa",
  css_class: "#12900",
  code: 12939,
  link: "dia-libre-cambio-casa",
  priority: nil,
  parent_id: b_free_time.id
)
#Días adicionales de vacaciones
General::Menu.find_or_create_by(
  title: "Días adicionales de vacaciones",
  description: "Días adicionales de vacaciones",
  css_class: "#14899",
  code: 14889,
  link: "dia-adicionales-vacaciones",
  priority: nil,
  parent_id: b_free_time.id
)
#Horarios de salida en días especiales 
General::Menu.find_or_create_by(
  title: "Horarios de salida en días especiales",
  description: "Horarios de salida en días especiales",
  css_class: "#12936",
  code: 12366,
  link: "horario-salida-dias-especiales",
  priority: nil,
  parent_id: b_free_time.id
)
#Examen de Grado 
General::Menu.find_or_create_by(
  title: "Examen de Grado",
  description: "Examen de Grado",
  css_class: "#11190",
  code: 12993,
  link: "examen-de-grado",
  priority: nil,
  parent_id: b_free_time.id
)
#Exámenes Preventivos
General::Menu.find_or_create_by(
  title: "Exámenes Preventivos",
  description: "Exámenes Preventivos",
  css_class: "#13403",
  code: 13849,
  link: "examenes-preventivos",
  priority: nil,
  parent_id: b_free_time.id
)
#->Familia
General::Menu.find_or_create_by(
  title: "Familia",
  description: "Familia",
  css_class: "#400jk3",
  code: 54888,
  link: "",
  priority: nil,
  parent_id: nil
)
family = General::Menu.find_by_title('Familia')
#Post Natal Paterno
General::Menu.find_or_create_by(
  title: "Post Natal Paterno",
  description: "Post Natal Paterno",
  css_class: "#400339",
  code: 43330,
  link: "familia-post-natal-paterno",
  priority: nil,
  parent_id: family.id
)
#Regreso Paulatino Materno
General::Menu.find_or_create_by(
  title: "Regreso Paulatino Materno",
  description: "Regreso Paulatino Materno",
  css_class: "#49000",
  code: 47888,
  link: "regreso-paulatino-materno",
  priority: nil,
  parent_id: family.id
)
#Securitylandia Verano - Invierno
General::Menu.find_or_create_by(
  title: "Securitylandia Verano - Invierno",
  description: "Securitylandia Verano - Invierno",
  css_class: "#444555",
  code: 41122,
  link: "securitylandia-verano-invierno",
  priority: nil,
  parent_id: family.id
)
#Tardes de Invierno
General::Menu.find_or_create_by(
  title: "Tardes de Invierno",
  description: "Tardes de Invierno",
  css_class: "#446788",
  code: 45678,
  link: "tardes-de-invierno",
  priority: nil,
  parent_id: family.id
)
#Premio Excelencia Académica
General::Menu.find_or_create_by(
  title: "Premio Excelencia Académica",
  description: "Premio Excelencia Académica",
  css_class: "#46777",
  code: 42200,
  link: "premio-excelencia-academica",
  priority: nil,
  parent_id: family.id
)
#Premio PSU
General::Menu.find_or_create_by(
  title: "Premio PSU",
  description: "Premio PSU",
  css_class: "#43989",
  code: 49002,
  link: "premio-psu",
  priority: nil,
  parent_id: family.id
)
#->Celebrando
General::Menu.find_or_create_by(
  title: "Celebrando",
  description: "Celebrando",
  css_class: "#o0293",
  code: 24849,
  link: "",
  priority: nil,
  parent_id: nil
)
celebrating = General::Menu.find_by_title('Celebrando')
#Cumpleaños
General::Menu.find_or_create_by(
  title: "Cumpleaños",
  description: "Cumpleaños",
  css_class: "#54321",
  code: 54564,
  link: "celebrando-cumpleanos",
  priority: nil,
  parent_id: celebrating.id
)
#Fiesta Fin de Año
General::Menu.find_or_create_by(
  title: "Fiesta Fin de Año",
  description: "Fiesta Fin de Año",
  css_class: "#54666",
  code: 55561,
  link: "celebrando-fiesta-fin-de-ano",
  priority: nil,
  parent_id: celebrating.id
)
#Paseo Grupo Security
General::Menu.find_or_create_by(
  title: "Paseo Grupo Security",
  description: "Paseo Grupo Security",
  css_class: "#57888",
  code: 50399,
  link: "celebrando-paseo-grupo-security",
  priority: nil,
  parent_id: celebrating.id
)
#Fiestas Patrias
General::Menu.find_or_create_by(
  title: "Fiestas Patrias",
  description: "Fiestas Patrias",
  css_class: "#54321",
  code: 54333,
  link: "celebrando-fiestas-patrias",
  priority: nil,
  parent_id: celebrating.id
)
#Nacimientos mini Security
General::Menu.find_or_create_by(
  title: "Nacimientos mini Security",
  description: "Nacimientos mini Security",
  css_class: "#51113",
  code: 51394,
  link: "celebrando-nacimiento-mini-security",
  priority: nil,
  parent_id: celebrating.id
)
#Regalo Inicio año escolar
General::Menu.find_or_create_by(
  title: "Regalo Inicio año escolar",
  description: "Regalo Inicio año escolar",
  css_class: "#50099",
  code: 56660,
  link: "celebrando-inicio-ano-escolar",
  priority: nil,
  parent_id: celebrating.id
)
#Pascua de Resurrección
General::Menu.find_or_create_by(
  title: "Pascua de Resurrección",
  description: "Pascua de Resurrección",
  css_class: "#56697",
  code: 51239,
  link: "celebrando-pascua-resurreccion",
  priority: nil,
  parent_id: celebrating.id
)
#Regalo de Navidad para hijos
General::Menu.find_or_create_by(
  title: "Regalo de Navidad para hijos",
  description: "Regalo de Navidad para hijos",
  css_class: "#56666",
  code: 57778,
  link: "celebrando-regalo-navidad-hijos",
  priority: nil,
  parent_id: celebrating.id
)
#Regalo Navidad con sentido
General::Menu.find_or_create_by(
  title: "Regalo Navidad con sentido",
  description: "Regalo Navidad con sentido",
  css_class: "#54111",
  code: 59992,
  link: "celebrando-regalo-navidad-con-sentido",
  priority: nil,
  parent_id: celebrating.id
)
#Regalo Día de la madre
General::Menu.find_or_create_by(
  title: "Regalo Día de la madre",
  description: "Regalo Día de la madre",
  css_class: "#55446",
  code: 55666,
  link: "celebrando-regalo-dia-madre",
  priority: nil,
  parent_id: celebrating.id
)
#Regalo Día de padre
General::Menu.find_or_create_by(
  title: "Regalo Día de padre",
  description: "Regalo Día de padre",
  css_class: "#51116",
  code: 51512,
  link: "celebrando-regalo-dia-padre",
  priority: nil,
  parent_id: celebrating.id
)
#Regalo Día del abuelo
General::Menu.find_or_create_by(
  title: "Regalo Día del abuelo",
  description: "Regalo Día del abuelo",
  css_class: "#59998",
  code: 51428,
  link: "celebrando-dia-abuelo",
  priority: nil,
  parent_id: celebrating.id
)
#Regalo Día de la mujer
General::Menu.find_or_create_by(
  title: "Regalo Día de la mujer",
  description: "Regalo Día de la mujer",
  css_class: "#58889",
  code: 52839,
  link: "celebrando-dia-mujer",
  priority: nil,
  parent_id: celebrating.id
)
#Regalo Día del abuelo
General::Menu.find_or_create_by(
  title: "Regalo Día del abuelo",
  description: "Regalo Día del abuelo",
  css_class: "#53428",
  code: 52937,
  link: "celebrando-dia-abuelo",
  priority: nil,
  parent_id: celebrating.id
)
#Regalo Pasamos Agosto 
General::Menu.find_or_create_by(
  title: "Regalo Pasamos Agosto",
  description: "Regalo Pasamos Agosto",
  css_class: "#51222",
  code: 52930,
  link: "celebrando-regalo-pasamos-agosto",
  priority: nil,
  parent_id: celebrating.id
)
#Día de la Secretaria
General::Menu.find_or_create_by(
  title: "Día de la Secretaria",
  description: "Día de la Secretaria",
  css_class: "#53339",
  code: 53390,
  link: "celebrando-dia-secretaria",
  priority: nil,
  parent_id: celebrating.id
)
#->Programa Yo Elijo Salud y Sustentabilidad
General::Menu.find_or_create_by(
  title: "Programa Yo Elijo Salud y Sustentabilidad",
  description: "Programa Yo Elijo Salud y Sustentabilidad",
  css_class: "#88863",
  code: 82536,
  link: "",
  priority: nil,
  parent_id: nil
)
healthy = General::Menu.find_by_title('Programa Yo Elijo Salud y Sustentabilidad')
#Fun Friday´s
General::Menu.find_or_create_by(
  title: "Fun Fridays",
  description: "Fun Fridays",
  css_class: "#53339",
  code: 53390,
  link: "celebrando-fun-fridays",
  priority: nil,
  parent_id: healthy.id
)
#Cuida tu Salud - Exámenes preventivos
General::Menu.find_or_create_by(
  title: "Cuida tu Salud - Exámenes preventivos",
  description: "Cuida tu Salud - Exámenes preventivos",
  css_class: "#59579",
  code: 53390,
  link: "celebrando-fun-fridays",
  priority: nil,
  parent_id: healthy.id
)
#Construcción de la Plaza
General::Menu.find_or_create_by(
  title: "Construcción de la Plaza",
  description: "Construcción de la Plaza",
  css_class: "#55677",
  code: 53388,
  link: "celebrando-construccion-plaza",
  priority: nil,
  parent_id: healthy.id
)
#Clases de cueca
General::Menu.find_or_create_by(
  title: "Clases de cueca",
  description: "Clases de cueca",
  css_class: "#53444",
  code: 56880,
  link: "celebrando-clases-cueca",
  priority: nil,
  parent_id: healthy.id
)
#Colación de Embarazadas
General::Menu.find_or_create_by(
  title: "Colación de Embarazadas",
  description: "Colación de Embarazadas",
  css_class: "#51110",
  code: 58880,
  link: "celebrando-colacion-embarazadas",
  priority: nil,
  parent_id: healthy.id
)
#Actividades deportivas
General::Menu.find_or_create_by(
  title: "Actividades deportivas",
  description: "Actividades deportivas",
  css_class: "#52020",
  code: 59000,
  link: "celebrando-actividades-deportivas",
  priority: nil,
  parent_id: healthy.id
)
#Charlas
General::Menu.find_or_create_by(
  title: "Charlas",
  description: "Charlas",
  css_class: "#56667",
  code: 59988,
  link: "celebrando-charlas",
  priority: nil,
  parent_id: healthy.id
)
#-> Convenios generales
General::Menu.find_or_create_by(
  title: "Convenios generales",
  description: "Convenios generales",
  css_class: "#32099",
  code: 10399,
  link: "",
  priority: nil,
  parent_id: nil
)
general = General::Menu.find_by_title('Convenios generales')
#Convenio Movistar
General::Menu.find_or_create_by(
  title: "Convenio Movistar",
  description: "Convenio Movistar",
  css_class: "#77889",
  code: 72377,
  link: "convenio-movistar",
  priority: nil,
  parent_id: general.id
)
#Convenios Restaurantes
General::Menu.find_or_create_by(
  title: "Convenios Restaurantes",
  description: "Convenios Restaurantes",
  css_class: "#76555",
  code: 72444,
  link: "convenio-movistar",
  priority: nil,
  parent_id: general.id
)
#Convenios Hoteles
General::Menu.find_or_create_by(
  title: "Convenios Hoteles",
  description: "Convenios Hoteles",
  css_class: "#71120",
  code: 78899,
  link: "convenio-hoteles",
  priority: nil,
  parent_id: general.id
)
#Convenios de Salud
General::Menu.find_or_create_by(
  title: "Convenios de Salud",
  description: "Convenios de Salud",
  css_class: "#77767",
  code: 72769,
  link: "convenio-salud",
  priority: nil,
  parent_id: general.id
)
#Convenios Dentales
General::Menu.find_or_create_by(
  title: "Convenios Dentales",
  description: "Convenios Dentales",
  css_class: "#788000",
  code: 774747,
  link: "convenios-dentales",
  priority: nil,
  parent_id: general.id
)
#Convenios Gimnasio
General::Menu.find_or_create_by(
  title: "Convenios Gimnasio",
  description: "Convenios Gimnasio",
  css_class: "#788993",
  code: 780300,
  link: "convenios-gimnasio",
  priority: nil,
  parent_id: general.id
)
#-> Convenios colectivos
General::Menu.find_or_create_by(
  title: "Convenios colectivos",
  description: "Convenios colectivos",
  css_class: "#32032",
  code: 10319,
  link: "",
  priority: nil,
  parent_id: nil
)
generalc = General::Menu.find_by_title('Convenios colectivos')
###########################################TERMINO MENÚ MIS BENEFICIOS 

####### FIN MENÚ NUEVO #######

# Menus Viejo
# General::Menu.find_or_create_by( 
#   title: "Bienvenidos",
#   description: "Listar los usuarios que llegaron a la empresa",
#   css_class: "#545454",
#   code: 1223,
#   link: "bienvenidos",
#   priority: nil,
#   parent_id: nil
# )
# General::Menu.find_or_create_by( 
#   title: "Nacimientos",
#   description: "Listar los hij@s de los empleados de la empresa",
#   css_class: "000001",
#   code: 1224,
#   link: "nacimientos",
#   priority: nil,
#   parent_id: nil
# )
# General::Menu.find_or_create_by( 
#   title: "Crear Nacimientos",
#   description: "Crear nacimiento",
#   css_class: "#ff00d5",
#   code: 1225,
#   link: "nacimientos3",
#   priority: nil,
#   parent_id: nil
# )
# General::Menu.find_or_create_by( 
#   title: "Cumpleanos",
#   description: "Listas cumpleaños de los empleados",
#   css_class: "#00ffbb",
#   code: 1226,
#   link: "cumpleaños",
#   priority: nil,
#   parent_id: nil
# )
# General::Menu.find_or_create_by(
#   title: "Productos",
#   description: "Listas productos",
#   css_class: "#000000",
#   code: 1227,
#   link: "avisos",
#   priority: nil,
#   parent_id: nil
# )
# General::Menu.find_or_create_by(
#   title: "Crear avisos",
#   description: "Crear Avisos",
#   css_class: "#1e5755",
#   code: 1231,
#   link: "avisos/find_or_create_by",
#   priority: nil,
#   parent_id: nil
# )
# General::Menu.find_or_create_by(
#   title: "Encuestas",
#   description: "Listas encuestas",
#   css_class: "#e3e3e3",
#   code: 1228,
#   link: "encuestas",
#   priority: nil,
#   parent_id: nil
# )
# General::Menu.find_or_create_by(
#   title: "Noticias",
#   description: "Listas de posts / noticias",
#   css_class: "#744db8",
#   code: 1229,
#   link: "noticias",
#   priority: nil,
#   parent_id: nil
# )
# General::Menu.find_or_create_by(
#   title: "Faq",
#   description: "preguntas y respuestas",
#   css_class: "#db9377",
#   code: 1230,
#   link: "preguntas-frecuentes",
#   priority: nil,
#   parent_id: nil
# )

############## SANTORAL ################
puts("******* Creando Santorales *******")
General::Santoral.find_or_create_by(name: "María, Madre de Dios", santoral_day: '01-01')
General::Santoral.find_or_create_by(name: "Basilio, Gregorio", santoral_day: '01-02')
General::Santoral.find_or_create_by(name: "Genoveva", santoral_day: '01-03')
General::Santoral.find_or_create_by(name: "Yolando, Rigoberto", santoral_day: '01-04')
General::Santoral.find_or_create_by(name: "Emilia", santoral_day: '01-05')
General::Santoral.find_or_create_by(name: "Wilma, Melanio", santoral_day: '01-06')
General::Santoral.find_or_create_by(name: "Raimundo", santoral_day: '01-07')
General::Santoral.find_or_create_by(name: "Luciano, Eladio", santoral_day: '01-08')
General::Santoral.find_or_create_by(name: "Lucrecia", santoral_day: '01-09')
General::Santoral.find_or_create_by(name: "Gonzalo", santoral_day: '01-10')
General::Santoral.find_or_create_by(name: "Alejandro", santoral_day: '01-11')
General::Santoral.find_or_create_by(name: "Julián", santoral_day: '01-12')
General::Santoral.find_or_create_by(name: "Hilario", santoral_day: '01-13')
General::Santoral.find_or_create_by(name: "Félix", santoral_day: '01-14')
General::Santoral.find_or_create_by(name: "Raquel, Mauro", santoral_day: '01-15')
General::Santoral.find_or_create_by(name: "Marcelo", santoral_day: '01-16')
General::Santoral.find_or_create_by(name: "Antonio, Guido", santoral_day: '01-17')
General::Santoral.find_or_create_by(name: "Prisca - Priscila", santoral_day: '01-18')
General::Santoral.find_or_create_by(name: "Mario", santoral_day: '01-19')
General::Santoral.find_or_create_by(name: "Sebastián, Fabián", santoral_day: '01-20')
General::Santoral.find_or_create_by(name: "Inés", santoral_day: '01-21')
General::Santoral.find_or_create_by(name: "Laura Vicuña, Vicente", santoral_day: '01-22')
General::Santoral.find_or_create_by(name: "Virginia", santoral_day: '01-23')
General::Santoral.find_or_create_by(name: "Francisco de Sales", santoral_day: '01-24')
General::Santoral.find_or_create_by(name: "Elvira", santoral_day: '01-25')
General::Santoral.find_or_create_by(name: "Timoteo, Tito, Paula - Paola", santoral_day: '01-26')
General::Santoral.find_or_create_by(name: "Ángela Merici", santoral_day: '01-27')
General::Santoral.find_or_create_by(name: "Tomás de Aquino", santoral_day: '01-28')
General::Santoral.find_or_create_by(name: "Valerio Martina", santoral_day: '01-29')
General::Santoral.find_or_create_by(name: "Martina de Roma", santoral_day: '01-30')
General::Santoral.find_or_create_by(name: "Juan Bosco, Marcela", santoral_day: '01-31')
General::Santoral.find_or_create_by(name: "Severiano", santoral_day: '02-01')
General::Santoral.find_or_create_by(name: "Presentación del Señor", santoral_day: '02-02')
General::Santoral.find_or_create_by(name: "Blas, Oscar", santoral_day: '02-03')
General::Santoral.find_or_create_by(name: "Gilberto", santoral_day: '02-04')
General::Santoral.find_or_create_by(name: "Agueda", santoral_day: '02-05')
General::Santoral.find_or_create_by(name: "Doris, Pablo Miki", santoral_day: '02-06')
General::Santoral.find_or_create_by(name: "Gastón", santoral_day: '02-07')
General::Santoral.find_or_create_by(name: "Jerónimo Emiliano, Jacqueline", santoral_day: '02-08')
General::Santoral.find_or_create_by(name: "Rebeca", santoral_day: '02-09')
General::Santoral.find_or_create_by(name: "Escolástica", santoral_day: '02-10')
General::Santoral.find_or_create_by(name: "N.Sra. de Lourdes", santoral_day: '02-11')
General::Santoral.find_or_create_by(name: "Panfilio, Pamela", santoral_day: '02-12')
General::Santoral.find_or_create_by(name: "Batriz", santoral_day: '02-13')
General::Santoral.find_or_create_by(name: "Cirilo, Metodio, Valentino", santoral_day: '02-14')
General::Santoral.find_or_create_by(name: "Fausto-ino, Jovita", santoral_day: '02-15')
General::Santoral.find_or_create_by(name: "Samuel", santoral_day: '02-16')
General::Santoral.find_or_create_by(name: "Alexis", santoral_day: '02-17')
General::Santoral.find_or_create_by(name: "Bernardita", santoral_day: '02-18')
General::Santoral.find_or_create_by(name: "Álvaro", santoral_day: '02-19')
General::Santoral.find_or_create_by(name: "Eleuterio, Claudio", santoral_day: '02-20')
General::Santoral.find_or_create_by(name: "Pedro Daminán, Severino", santoral_day: '02-21')
General::Santoral.find_or_create_by(name: "Eleonora, Nora", santoral_day: '02-22')
General::Santoral.find_or_create_by(name: "Florencio", santoral_day: '02-23')
General::Santoral.find_or_create_by(name: "Rubén, Sergio", santoral_day: '02-24')
General::Santoral.find_or_create_by(name: "Néstor", santoral_day: '02-25')
General::Santoral.find_or_create_by(name: "Augusto", santoral_day: '02-26')
General::Santoral.find_or_create_by(name: "Leandro, Gabriel Dol", santoral_day: '02-27')
General::Santoral.find_or_create_by(name: "Román", santoral_day: '02-28')
General::Santoral.find_or_create_by(name: "Bisiesto", santoral_day: '02-29') if es_bisiesto?(Date.today.year)
General::Santoral.find_or_create_by(name: "Rosendo", santoral_day: '03-01')
General::Santoral.find_or_create_by(name: "Lucio", santoral_day: '03-02')
General::Santoral.find_or_create_by(name: "Celedonio", santoral_day: '03-03')
General::Santoral.find_or_create_by(name: "Ariel", santoral_day: '03-04')
General::Santoral.find_or_create_by(name: "Olivia", santoral_day: '03-05')
General::Santoral.find_or_create_by(name: "Elcira", santoral_day: '03-06')
General::Santoral.find_or_create_by(name: "Perpétua, Felicidad", santoral_day: '03-07')
General::Santoral.find_or_create_by(name: "Juan de Dios", santoral_day: '03-08')
General::Santoral.find_or_create_by(name: "Francisca Romana", santoral_day: '03-09')
General::Santoral.find_or_create_by(name: "Macario", santoral_day: '03-10')
General::Santoral.find_or_create_by(name: "Eulogio", santoral_day: '03-11')
General::Santoral.find_or_create_by(name: "Norma", santoral_day: '03-12')
General::Santoral.find_or_create_by(name: "Rodrigo", santoral_day: '03-13')
General::Santoral.find_or_create_by(name: "Matilde", santoral_day: '03-14')
General::Santoral.find_or_create_by(name: "Luisa de Marillac", santoral_day: '03-15')
General::Santoral.find_or_create_by(name: "Heriberto", santoral_day: '03-16')
General::Santoral.find_or_create_by(name: "Patricio", santoral_day: '03-17')
General::Santoral.find_or_create_by(name: "Cirilo", santoral_day: '03-18')
General::Santoral.find_or_create_by(name: "José", santoral_day: '03-19')
General::Santoral.find_or_create_by(name: "Alejandra", santoral_day: '03-20')
General::Santoral.find_or_create_by(name: "Eugenia", santoral_day: '03-21')
General::Santoral.find_or_create_by(name: "Lea", santoral_day: '03-22')
General::Santoral.find_or_create_by(name: "Dimas", santoral_day: '03-23')
General::Santoral.find_or_create_by(name: "Elba, Catalina de Suecia", santoral_day: '03-24')
General::Santoral.find_or_create_by(name: "Anunciación", santoral_day: '03-25')
General::Santoral.find_or_create_by(name: "Braulio", santoral_day: '03-26')
General::Santoral.find_or_create_by(name: "Ruperto", santoral_day: '03-27')
General::Santoral.find_or_create_by(name: "Octavio", santoral_day: '03-28')
General::Santoral.find_or_create_by(name: "Gladys", santoral_day: '03-29')
General::Santoral.find_or_create_by(name: "Artemio", santoral_day: '03-30')
General::Santoral.find_or_create_by(name: "Benjamín, Balbina", santoral_day: '03-31')
General::Santoral.find_or_create_by(name: "Hugo", santoral_day: '04-01')
General::Santoral.find_or_create_by(name: "Sandra, Francisco de Paula", santoral_day: '04-02')
General::Santoral.find_or_create_by(name: "Ricardo", santoral_day: '04-03')
General::Santoral.find_or_create_by(name: "Isidoro", santoral_day: '04-04')
General::Santoral.find_or_create_by(name: "Vicente Ferrer", santoral_day: '04-05')
General::Santoral.find_or_create_by(name: "Edith", santoral_day: '04-06')
General::Santoral.find_or_create_by(name: "Juan Bautista de La Salle", santoral_day: '04-07')
General::Santoral.find_or_create_by(name: "Constanza", santoral_day: '04-08')
General::Santoral.find_or_create_by(name: "Demetrio", santoral_day: '04-09')
General::Santoral.find_or_create_by(name: "Ezequiel", santoral_day: '04-10')
General::Santoral.find_or_create_by(name: "Estanislao", santoral_day: '04-11')
General::Santoral.find_or_create_by(name: "Arnoldo, Julio", santoral_day: '04-12')
General::Santoral.find_or_create_by(name: "Martín, Aída", santoral_day: '04-13')
General::Santoral.find_or_create_by(name: "Máximo", santoral_day: '04-14')
General::Santoral.find_or_create_by(name: "Crescente", santoral_day: '04-15')
General::Santoral.find_or_create_by(name: "Flavio", santoral_day: '04-16')
General::Santoral.find_or_create_by(name: "Leopoldo, Aniceto", santoral_day: '04-17')
General::Santoral.find_or_create_by(name: "Wladimir", santoral_day: '04-18')
General::Santoral.find_or_create_by(name: "Ema", santoral_day: '04-19')
General::Santoral.find_or_create_by(name: "Edgardo", santoral_day: '04-20')
General::Santoral.find_or_create_by(name: "Anselmo", santoral_day: '04-21')
General::Santoral.find_or_create_by(name: "Karina", santoral_day: '04-22')
General::Santoral.find_or_create_by(name: "Jorge", santoral_day: '04-23')
General::Santoral.find_or_create_by(name: "Fidel", santoral_day: '04-24')
General::Santoral.find_or_create_by(name: "Marcos", santoral_day: '04-25')
General::Santoral.find_or_create_by(name: "Cleto, Marcelino", santoral_day: '04-26')
General::Santoral.find_or_create_by(name: "Zita, Toribio de Mogrovejo", santoral_day: '04-27')
General::Santoral.find_or_create_by(name: "Valeria", santoral_day: '04-28')
General::Santoral.find_or_create_by(name: "Catalina de Siena", santoral_day: '04-29')
General::Santoral.find_or_create_by(name: "Amador, Pío V", santoral_day: '04-30')
General::Santoral.find_or_create_by(name: "José Obrero", santoral_day: '05-01')
General::Santoral.find_or_create_by(name: "Atanasio, Boris", santoral_day: '05-02')
General::Santoral.find_or_create_by(name: "Santa Cruz", santoral_day: '05-03')
General::Santoral.find_or_create_by(name: "Felipe y Santiago", santoral_day: '05-04')
General::Santoral.find_or_create_by(name: "Judit", santoral_day: '05-05')
General::Santoral.find_or_create_by(name: "Eleodoro", santoral_day: '05-06')
General::Santoral.find_or_create_by(name: "Domitila", santoral_day: '05-07')
General::Santoral.find_or_create_by(name: "Segundo", santoral_day: '05-08')
General::Santoral.find_or_create_by(name: "Isaías", santoral_day: '05-09')
General::Santoral.find_or_create_by(name: "Antonino-a, Solange", santoral_day: '05-10')
General::Santoral.find_or_create_by(name: "Estela", santoral_day: '05-11')
General::Santoral.find_or_create_by(name: "Pancracio, Nereo, Aquiles", santoral_day: '05-12')
General::Santoral.find_or_create_by(name: "N.S. Fátima", santoral_day: '05-13')
General::Santoral.find_or_create_by(name: "Matías", santoral_day: '05-14')
General::Santoral.find_or_create_by(name: "Isidro, Denise", santoral_day: '05-15')
General::Santoral.find_or_create_by(name: "Honorato", santoral_day: '05-16')
General::Santoral.find_or_create_by(name: "Pascual Bailón", santoral_day: '05-17')
General::Santoral.find_or_create_by(name: "Erica, Corina", santoral_day: '05-18')
General::Santoral.find_or_create_by(name: "Yvo-ne", santoral_day: '05-19')
General::Santoral.find_or_create_by(name: "Bernardino de Siena", santoral_day: '05-20')
General::Santoral.find_or_create_by(name: "Constantino", santoral_day: '05-21')
General::Santoral.find_or_create_by(name: "Rita", santoral_day: '05-22')
General::Santoral.find_or_create_by(name: "Desiderio", santoral_day: '05-23')
General::Santoral.find_or_create_by(name: "María Auxiliadora, Susana", santoral_day: '05-24')
General::Santoral.find_or_create_by(name: "Beda, Gregorio, Ma.Magdalena de Pazzi", santoral_day: '05-25')
General::Santoral.find_or_create_by(name: "Mariana", santoral_day: '05-26')
General::Santoral.find_or_create_by(name: "Emilio, Agustín de Cantorbery", santoral_day: '05-27')
General::Santoral.find_or_create_by(name: "Germán", santoral_day: '05-28')
General::Santoral.find_or_create_by(name: "Maximiano, Hilda", santoral_day: '05-29')
General::Santoral.find_or_create_by(name: "Fernando/Hernán, Juana de Arco, Lorena", santoral_day: '05-30')
General::Santoral.find_or_create_by(name: "Visitación", santoral_day: '05-31')
General::Santoral.find_or_create_by(name: "Justino, Juvenal", santoral_day: '06-01')
General::Santoral.find_or_create_by(name: "Marcelino, Erasmo", santoral_day: '06-02')
General::Santoral.find_or_create_by(name: "Maximiliano, Carlos Lwanga", santoral_day: '06-03')
General::Santoral.find_or_create_by(name: "Frida", santoral_day: '06-04')
General::Santoral.find_or_create_by(name: "Bonifacio, Salvador", santoral_day: '06-05')
General::Santoral.find_or_create_by(name: "Norberto", santoral_day: '06-06')
General::Santoral.find_or_create_by(name: "Claudio", santoral_day: '06-07')
General::Santoral.find_or_create_by(name: "Armando", santoral_day: '06-08')
General::Santoral.find_or_create_by(name: "Efr&eacuten", santoral_day: '06-09')
General::Santoral.find_or_create_by(name: "Paulina", santoral_day: '06-10')
General::Santoral.find_or_create_by(name: "Bernabé, Trinidad", santoral_day: '06-11')
General::Santoral.find_or_create_by(name: "Onofre", santoral_day: '06-12')
General::Santoral.find_or_create_by(name: "Antonio", santoral_day: '06-13')
General::Santoral.find_or_create_by(name: "Eliseo", santoral_day: '06-14')
General::Santoral.find_or_create_by(name: "Leonidas, Manuela, Micaela", santoral_day: '06-15')
General::Santoral.find_or_create_by(name: "Aurelio", santoral_day: '06-16')
General::Santoral.find_or_create_by(name: "Ismael", santoral_day: '06-17')
General::Santoral.find_or_create_by(name: "Salom&oacuten", santoral_day: '06-18')
General::Santoral.find_or_create_by(name: "Romualdo", santoral_day: '06-19')
General::Santoral.find_or_create_by(name: "Florentino", santoral_day: '06-20')
General::Santoral.find_or_create_by(name: "Raul, Rodolfo, Lu&iacutes Gonzaga", santoral_day: '06-21')
General::Santoral.find_or_create_by(name: "Paulino de Nola, Tomáss Moro, Juan Fisher", santoral_day: '06-22')
General::Santoral.find_or_create_by(name: "Marcial", santoral_day: '06-23')
General::Santoral.find_or_create_by(name: "Juan Bautista", santoral_day: '06-24')
General::Santoral.find_or_create_by(name: "Guillermo", santoral_day: '06-25')
General::Santoral.find_or_create_by(name: "Pelayo", santoral_day: '06-26')
General::Santoral.find_or_create_by(name: "Cirilo", santoral_day: '06-27')
General::Santoral.find_or_create_by(name: "Ireneo", santoral_day: '06-28')
General::Santoral.find_or_create_by(name: "Pedro y Pablo", santoral_day: '06-29')
General::Santoral.find_or_create_by(name: "Adolfo", santoral_day: '06-30')
General::Santoral.find_or_create_by(name: "Ester", santoral_day: '07-01')
General::Santoral.find_or_create_by(name: "Gloria", santoral_day: '07-02')
General::Santoral.find_or_create_by(name: "Tomás", santoral_day: '07-03')
General::Santoral.find_or_create_by(name: "Isabel, Eliana, Liliana", santoral_day: '07-04')
General::Santoral.find_or_create_by(name: "Antonio-María, Berta", santoral_day: '07-05')
General::Santoral.find_or_create_by(name: "María Goretti", santoral_day: '07-06')
General::Santoral.find_or_create_by(name: "Fermín", santoral_day: '07-07')
General::Santoral.find_or_create_by(name: "Eugenio", santoral_day: '07-08')
General::Santoral.find_or_create_by(name: "Verónica", santoral_day: '07-09')
General::Santoral.find_or_create_by(name: "Elías", santoral_day: '07-10')
General::Santoral.find_or_create_by(name: "Benito", santoral_day: '07-11')
General::Santoral.find_or_create_by(name: "Filomena", santoral_day: '07-12')
General::Santoral.find_or_create_by(name: "Teresa de los Andes, Enrique, Joel", santoral_day: '07-13')
General::Santoral.find_or_create_by(name: "Camilo de Lelis", santoral_day: '07-14')
General::Santoral.find_or_create_by(name: "Buenaventura, Julio/a", santoral_day: '07-15')
General::Santoral.find_or_create_by(name: "Carmen", santoral_day: '07-16')
General::Santoral.find_or_create_by(name: "Carolina", santoral_day: '07-17')
General::Santoral.find_or_create_by(name: "Federico", santoral_day: '07-18')
General::Santoral.find_or_create_by(name: "Arsenio", santoral_day: '07-19')
General::Santoral.find_or_create_by(name: "Marina", santoral_day: '07-20')
General::Santoral.find_or_create_by(name: "Daniel", santoral_day: '07-21')
General::Santoral.find_or_create_by(name: "María Magdalena", santoral_day: '07-22')
General::Santoral.find_or_create_by(name: "Brigida", santoral_day: '07-23')
General::Santoral.find_or_create_by(name: "Cristina", santoral_day: '07-24')
General::Santoral.find_or_create_by(name: "Santiago", santoral_day: '07-25')
General::Santoral.find_or_create_by(name: "Joaquín, Ana", santoral_day: '07-26')
General::Santoral.find_or_create_by(name: "Natalia", santoral_day: '07-27')
General::Santoral.find_or_create_by(name: "Celso", santoral_day: '07-28')
General::Santoral.find_or_create_by(name: "Marta", santoral_day: '07-29')
General::Santoral.find_or_create_by(name: "Abdón y Senén", santoral_day: '07-30')
General::Santoral.find_or_create_by(name: "Ignacio de Loyola", santoral_day: '07-31')
General::Santoral.find_or_create_by(name: "Alfonso María de Ligorio", santoral_day: '08-01')
General::Santoral.find_or_create_by(name: "Eusebio", santoral_day: '08-02')
General::Santoral.find_or_create_by(name: "Lydia", santoral_day: '08-03')
General::Santoral.find_or_create_by(name: "Juan María Vianney", santoral_day: '08-04')
General::Santoral.find_or_create_by(name: "Osvaldo, Nieves", santoral_day: '08-05')
General::Santoral.find_or_create_by(name: "(Transfiguración)", santoral_day: '08-06')
General::Santoral.find_or_create_by(name: "Sixto, Cayetano", santoral_day: '08-07')
General::Santoral.find_or_create_by(name: "Domingo de Guzmán", santoral_day: '08-08')
General::Santoral.find_or_create_by(name: "Justo", santoral_day: '08-09')
General::Santoral.find_or_create_by(name: "Lorenzo", santoral_day: '08-10')
General::Santoral.find_or_create_by(name: "Clara de Asís", santoral_day: '08-11')
General::Santoral.find_or_create_by(name: "Laura", santoral_day: '08-12')
General::Santoral.find_or_create_by(name: "Víctor", santoral_day: '08-13')
General::Santoral.find_or_create_by(name: "Maximiliano Kolbe, Alfredo", santoral_day: '08-14')
General::Santoral.find_or_create_by(name: "Asunción", santoral_day: '08-15')
General::Santoral.find_or_create_by(name: "Esteban de Hungría, Roque", santoral_day: '08-16')
General::Santoral.find_or_create_by(name: "Jacinto", santoral_day: '08-17')
General::Santoral.find_or_create_by(name: "Alberto Hurtado, Elena, Nelly, Leticia", santoral_day: '08-18')
General::Santoral.find_or_create_by(name: "Mariano", santoral_day: '08-19')
General::Santoral.find_or_create_by(name: "Bernardo", santoral_day: '08-20')
General::Santoral.find_or_create_by(name: "Pío X, Graciela", santoral_day: '08-21')
General::Santoral.find_or_create_by(name: "María Reina", santoral_day: '08-22')
General::Santoral.find_or_create_by(name: "Donato", santoral_day: '08-23')
General::Santoral.find_or_create_by(name: "Bartolomé", santoral_day: '08-24')
General::Santoral.find_or_create_by(name: "Luís (rey), José Calasanz", santoral_day: '08-25')
General::Santoral.find_or_create_by(name: "Teresa de Jesús Jornet e Ibars, César", santoral_day: '08-26')
General::Santoral.find_or_create_by(name: "Mónica", santoral_day: '08-27')
General::Santoral.find_or_create_by(name: "Agustín", santoral_day: '08-28')
General::Santoral.find_or_create_by(name: "Juan Bautista, Sabina", santoral_day: '08-29')
General::Santoral.find_or_create_by(name: "Rosa de Lima", santoral_day: '08-30')
General::Santoral.find_or_create_by(name: "Ramón", santoral_day: '08-31')
General::Santoral.find_or_create_by(name: "Arturo", santoral_day: '09-01')
General::Santoral.find_or_create_by(name: "Moisés", santoral_day: '09-02')
General::Santoral.find_or_create_by(name: "Gregorio Magno", santoral_day: '09-03')
General::Santoral.find_or_create_by(name: "Irma", santoral_day: '09-04')
General::Santoral.find_or_create_by(name: "Victorino", santoral_day: '09-05')
General::Santoral.find_or_create_by(name: "Eva, Evelyne", santoral_day: '09-06')
General::Santoral.find_or_create_by(name: "Regina", santoral_day: '09-07')
General::Santoral.find_or_create_by(name: "Natividad de la Virgen", santoral_day: '09-08')
General::Santoral.find_or_create_by(name: "Sergio y Omar", santoral_day: '09-09')
General::Santoral.find_or_create_by(name: "Nicolás de Tolentino, Adalberto", santoral_day: '09-10')
General::Santoral.find_or_create_by(name: "Orlando, Rolando", santoral_day: '09-11')
General::Santoral.find_or_create_by(name: "María", santoral_day: '09-12')
General::Santoral.find_or_create_by(name: "Juan Crisóstomo", santoral_day: '09-13')
General::Santoral.find_or_create_by(name: "Imelda", santoral_day: '09-14')
General::Santoral.find_or_create_by(name: "N.Sra.de Dolores", santoral_day: '09-15')
General::Santoral.find_or_create_by(name: "Cornelio, Cipriano", santoral_day: '09-16')
General::Santoral.find_or_create_by(name: "Roberto Belarmino", santoral_day: '09-17')
General::Santoral.find_or_create_by(name: "José de Cupertino", santoral_day: '09-18')
General::Santoral.find_or_create_by(name: "Jenaro", santoral_day: '09-19')
General::Santoral.find_or_create_by(name: "Amelia, Andrés Kim y Pablo Tung", santoral_day: '09-20')
General::Santoral.find_or_create_by(name: "Mateo", santoral_day: '09-21')
General::Santoral.find_or_create_by(name: "Mauricio", santoral_day: '09-22')
General::Santoral.find_or_create_by(name: "Lino y Tecla", santoral_day: '09-23')
General::Santoral.find_or_create_by(name: "N.Sra.del Carmen", santoral_day: '09-24')
General::Santoral.find_or_create_by(name: "Aurelio", santoral_day: '09-25')
General::Santoral.find_or_create_by(name: "Cosme y Damián", santoral_day: '09-26')
General::Santoral.find_or_create_by(name: "Vicente de Paul", santoral_day: '09-27')
General::Santoral.find_or_create_by(name: "Wenceslao", santoral_day: '09-28')
General::Santoral.find_or_create_by(name: "Miguel, Gabriel y Rafael", santoral_day: '09-29')
General::Santoral.find_or_create_by(name: "Jerónimo", santoral_day: '09-30')
General::Santoral.find_or_create_by(name: "Teresita del Niño Jesús", santoral_day: '10-01')
General::Santoral.find_or_create_by(name: "Angeles Custodios", santoral_day: '10-02')
General::Santoral.find_or_create_by(name: "Gerardo", santoral_day: '10-03')
General::Santoral.find_or_create_by(name: "Francisco de Asís", santoral_day: '10-04')
General::Santoral.find_or_create_by(name: "Flor", santoral_day: '10-05')
General::Santoral.find_or_create_by(name: "Bruno", santoral_day: '10-06')
General::Santoral.find_or_create_by(name: "N.Sra.del Rosario", santoral_day: '10-07')
General::Santoral.find_or_create_by(name: "N.Sra.de Begoña", santoral_day: '10-08')
General::Santoral.find_or_create_by(name: "Dionisio; Juan Leonardi", santoral_day: '10-09')
General::Santoral.find_or_create_by(name: "Francisco de Borja", santoral_day: '10-10')
General::Santoral.find_or_create_by(name: "Soledad", santoral_day: '10-11')
General::Santoral.find_or_create_by(name: "N.Sra.del Pilar", santoral_day: '10-12')
General::Santoral.find_or_create_by(name: "Eduardo", santoral_day: '10-13')
General::Santoral.find_or_create_by(name: "Calixto", santoral_day: '10-14')
General::Santoral.find_or_create_by(name: "Teresa de Avila", santoral_day: '10-15')
General::Santoral.find_or_create_by(name: "Eduvigis, Margarita Ma.Alacoque", santoral_day: '10-16')
General::Santoral.find_or_create_by(name: "Ignacio de Antioquía", santoral_day: '10-17')
General::Santoral.find_or_create_by(name: "Lucas", santoral_day: '10-18')
General::Santoral.find_or_create_by(name: "Pablo de la Cruz, Renato", santoral_day: '10-19')
General::Santoral.find_or_create_by(name: "Irene", santoral_day: '10-20')
General::Santoral.find_or_create_by(name: "Úrsula", santoral_day: '10-21')
General::Santoral.find_or_create_by(name: "Sara", santoral_day: '10-22')
General::Santoral.find_or_create_by(name: "Juan Capistrano, Remigio", santoral_day: '10-23')
General::Santoral.find_or_create_by(name: "Antonio Ma.Claret", santoral_day: '10-24')
General::Santoral.find_or_create_by(name: "Olga", santoral_day: '10-25')
General::Santoral.find_or_create_by(name: "Darío", santoral_day: '10-26')
General::Santoral.find_or_create_by(name: "Gustavo", santoral_day: '10-27')
General::Santoral.find_or_create_by(name: "Simón, Judas", santoral_day: '10-28')
General::Santoral.find_or_create_by(name: "Narciso", santoral_day: '10-29')
General::Santoral.find_or_create_by(name: "Alonso", santoral_day: '10-30')
General::Santoral.find_or_create_by(name: "Quintin", santoral_day: '10-31')
General::Santoral.find_or_create_by(name: "Todos los Santos", santoral_day: '11-01')
General::Santoral.find_or_create_by(name: "Todos los Fieles difuntos", santoral_day: '11-02')
General::Santoral.find_or_create_by(name: "Martín de Porres", santoral_day: '11-03')
General::Santoral.find_or_create_by(name: "Carlos Borromeo", santoral_day: '11-04')
General::Santoral.find_or_create_by(name: "Silvia", santoral_day: '11-05')
General::Santoral.find_or_create_by(name: "Leonardo", santoral_day: '11-06')
General::Santoral.find_or_create_by(name: "Ernesto-ina", santoral_day: '11-07')
General::Santoral.find_or_create_by(name: "Ninfa, Godofredo", santoral_day: '11-08')
General::Santoral.find_or_create_by(name: "Teodoro", santoral_day: '11-09')
General::Santoral.find_or_create_by(name: "León Magno", santoral_day: '11-10')
General::Santoral.find_or_create_by(name: "Martín de Tours", santoral_day: '11-11')
General::Santoral.find_or_create_by(name: "Cristián", santoral_day: '11-12')
General::Santoral.find_or_create_by(name: "Diego", santoral_day: '11-13')
General::Santoral.find_or_create_by(name: "Humberto", santoral_day: '11-14')
General::Santoral.find_or_create_by(name: "Alberto Magno", santoral_day: '11-15')
General::Santoral.find_or_create_by(name: "Margarita, Gertrudis", santoral_day: '11-16')
General::Santoral.find_or_create_by(name: "Isabel de Hungría", santoral_day: '11-17')
General::Santoral.find_or_create_by(name: "Elsa", santoral_day: '11-18')
General::Santoral.find_or_create_by(name: "Andrés Avelino", santoral_day: '11-19')
General::Santoral.find_or_create_by(name: "Edmundo", santoral_day: '11-20')
General::Santoral.find_or_create_by(name: "Presentación de la Virgen", santoral_day: '11-21')
General::Santoral.find_or_create_by(name: "Cecilia", santoral_day: '11-22')
General::Santoral.find_or_create_by(name: "Clemento, Columbano", santoral_day: '11-23')
General::Santoral.find_or_create_by(name: "Flora, Andrés Dung-Lac", santoral_day: '11-24')
General::Santoral.find_or_create_by(name: "Catalina Labouré", santoral_day: '11-25')
General::Santoral.find_or_create_by(name: "Delfina", santoral_day: '11-26')
General::Santoral.find_or_create_by(name: "Virgilio", santoral_day: '11-27')
General::Santoral.find_or_create_by(name: "Blanca", santoral_day: '11-28')
General::Santoral.find_or_create_by(name: "Saturnino", santoral_day: '11-29')
General::Santoral.find_or_create_by(name: "Andrés", santoral_day: '11-30')
General::Santoral.find_or_create_by(name: "Florencia", santoral_day: '12-01')
General::Santoral.find_or_create_by(name: "Viviana", santoral_day: '12-02')
General::Santoral.find_or_create_by(name: "Francisco Javier", santoral_day: '12-03')
General::Santoral.find_or_create_by(name: "Juan Damaceno, Bárbara", santoral_day: '12-04')
General::Santoral.find_or_create_by(name: "Ada", santoral_day: '12-05')
General::Santoral.find_or_create_by(name: "Nicolás", santoral_day: '12-06')
General::Santoral.find_or_create_by(name: "Ambrosio", santoral_day: '12-07')
General::Santoral.find_or_create_by(name: "Inmaculada Concepción", santoral_day: '12-08')
General::Santoral.find_or_create_by(name: "Jéssica", santoral_day: '12-09')
General::Santoral.find_or_create_by(name: "N. Sra. de Loreto, Eulalia", santoral_day: '12-10')
General::Santoral.find_or_create_by(name: "Dámaso", santoral_day: '12-11')
General::Santoral.find_or_create_by(name: "N. Sra. de Guadalupe", santoral_day: '12-12')
General::Santoral.find_or_create_by(name: "Lucía", santoral_day: '12-13')
General::Santoral.find_or_create_by(name: "Juan de la Cruz", santoral_day: '12-14')
General::Santoral.find_or_create_by(name: "Reinaldo", santoral_day: '12-15')
General::Santoral.find_or_create_by(name: "Alicia", santoral_day: '12-16')
General::Santoral.find_or_create_by(name: "Lázaro", santoral_day: '12-17')
General::Santoral.find_or_create_by(name: "Sonia", santoral_day: '12-18')
General::Santoral.find_or_create_by(name: "Urbano", santoral_day: '12-19')
General::Santoral.find_or_create_by(name: "Abrahám, Isaac, Jacob", santoral_day: '12-20')
General::Santoral.find_or_create_by(name: "Pedro Canisio", santoral_day: '12-21')
General::Santoral.find_or_create_by(name: "Fabiola", santoral_day: '12-22')
General::Santoral.find_or_create_by(name: "Victoria", santoral_day: '12-23')
General::Santoral.find_or_create_by(name: "Adela", santoral_day: '12-24')
General::Santoral.find_or_create_by(name: "Natividad del Señor (Noel, Noelia)", santoral_day: '12-25')
General::Santoral.find_or_create_by(name: "Esteban", santoral_day: '12-26')
General::Santoral.find_or_create_by(name: "Juan", santoral_day: '12-27')
General::Santoral.find_or_create_by(name: "Stos. Inocentes", santoral_day: '12-28')
General::Santoral.find_or_create_by(name: "Tomás Becket, David", santoral_day: '12-29')
General::Santoral.find_or_create_by(name: "Rogelio", santoral_day: '12-30')
General::Santoral.find_or_create_by(name: "Silvestre", santoral_day: '12-31')
# benefit group
puts("******* Creando Grupos de Beneficios *******")
General::BenefitGroup.find_or_create_by(code:"ASCTY-0",name: "ASESORIAS SECURITY - SIN SINDICATO", description: "ASESORIAS SECURITY - SIN SINDICATO")
General::BenefitGroup.find_or_create_by(code:"ASCTY-1",name: "ASESORIAS SECURITY - EXTENSIÓN BENEF INVERSIONES", description: "ASESORIAS SECURITY - EXTENSIÓN BENEF INVERSIONES")
General::BenefitGroup.find_or_create_by(code:"ASCTY-2",name: "ASESORIAS SECURITY - EXTEN DE BENEF INVERSIONES FFVV", description: "ASESORIAS SECURITY - EXTEN DE BENEF INVERSIONES FFVV")
General::BenefitGroup.find_or_create_by(code:"BSCTY-0",name: "BANCO SECURITY - SIN SINDICATO", description: "BANCO SECURITY - SIN SINDICATO")
General::BenefitGroup.find_or_create_by(code:"BSCTY-1",name: "BANCO SECURITY - S. TRABAJADORES BANCO", description: "BANCO SECURITY - S. TRABAJADORES BANCO")
General::BenefitGroup.find_or_create_by(code:"BSCTY-2",name: "BANCO SECURITY - S. NACIONAL BANCO", description: "BANCO SECURITY - S. NACIONAL BANCO")
General::BenefitGroup.find_or_create_by(code:"CSCTY-0",name: "CORREDORA DE SEGUROS SECURITY - SIN SINDICATO", description: "CORREDORA DE SEGUROS SECURITY - SIN SINDICATO")
General::BenefitGroup.find_or_create_by(code:"FMCTY-0",name: "ADM GRAL DE FONDOS SECURITY - SIN SINDICATO", description: "ADM GRAL DE FONDOS SECURITY - SIN SINDICATO")
General::BenefitGroup.find_or_create_by(code:"FMCTY-1",name: "ADM GRAL DE FONDOS SECURITY - EXTENSIÓN BENEF INVERSIONES", description: "ADM GRAL DE FONDOS SECURITY - EXTENSIÓN BENEF INVERSIONES")
General::BenefitGroup.find_or_create_by(code:"FMCTY-2",name: "ADM GRAL DE FONDOS SECURITY - EXTEN DE BENEF INVERSIONES FFVV", description: "ADM GRAL DE FONDOS SECURITY - EXTEN DE BENEF INVERSIONES FFVV")
General::BenefitGroup.find_or_create_by(code:"FSCTY-0",name: "FACTORING SECURITY - SIN SINDICATO", description: "FACTORING SECURITY - SIN SINDICATO")
General::BenefitGroup.find_or_create_by(code:"FSCTY-1",name: "FACTORING SECURITY - SINDICATO NACIONAL FACTORING", description: "FACTORING SECURITY - SINDICATO NACIONAL FACTORING")
General::BenefitGroup.find_or_create_by(code:"GRCTY-0",name: "GRUPO SECURITY - SIN SINDICATO", description: "GRUPO SECURITY - SIN SINDICATO")
General::BenefitGroup.find_or_create_by(code:"GRCTY-1",name: "GRUPO SECURITY - EXTENSIÓN DE BENEFICIOS", description: "GRUPO SECURITY - EXTENSIÓN DE BENEFICIOS")
General::BenefitGroup.find_or_create_by(code:"GSCTY-0",name: "GLOBAL SECURITY - SIN SINDICATO", description: "GLOBAL SECURITY - SIN SINDICATO")
General::BenefitGroup.find_or_create_by(code:"GSCTY-1",name: "GLOBAL SECURITY - EXTENSIÓN BENEF INVERSIONES", description: "GLOBAL SECURITY - EXTENSIÓN BENEF INVERSIONES")
General::BenefitGroup.find_or_create_by(code:"GSCTY-2",name: "GLOBAL SECURITY - EXTEN DE BENEF INVERSIONES FFVV", description: "GLOBAL SECURITY - EXTEN DE BENEF INVERSIONES FFVV")
General::BenefitGroup.find_or_create_by(code:"HICDS-0",name: "HIPOTECARIA SECURITY PRINCIPAL S.A - GERENTES Y SUBGTES", description: "HIPOTECARIA SECURITY PRINCIPAL S.A - GERENTES Y SUBGTES")
General::BenefitGroup.find_or_create_by(code:"HICDS-1",name: "HIPOTECARIA SECURITY PRINCIPAL S.A - TRABAJADORES", description: "HIPOTECARIA SECURITY PRINCIPAL S.A - TRABAJADORES")
General::BenefitGroup.find_or_create_by(code:"INVST-0",name: "CAPITAL - SIN SINDICATO", description: "CAPITAL - SIN SINDICATO")
General::BenefitGroup.find_or_create_by(code:"INVST-1",name: "CAPITAL - EXTENSIÓN BENEF INVERSIONES", description: "CAPITAL - EXTENSIÓN BENEF INVERSIONES")
General::BenefitGroup.find_or_create_by(code:"INVST-2",name: "CAPITAL - EXTENSIÓN DE BENEFICIOS", description: "CAPITAL - EXTENSIÓN DE BENEFICIOS")
General::BenefitGroup.find_or_create_by(code:"ISC07-0",name: "INMOBILIARIA SECURITY SIETE - SIN SINDICATO", description: "INMOBILIARIA SECURITY SIETE - SIN SINDICATO")
General::BenefitGroup.find_or_create_by(code:"ISC07-1",name: "INMOBILIARIA SECURITY SIETE - EXTENSIÓN BENEF INMOBILIARIA 7", description: "INMOBILIARIA SECURITY SIETE - EXTENSIÓN BENEF INMOBILIARIA 7")
General::BenefitGroup.find_or_create_by(code:"ISCTY-0",name: "INMOBILIARIA SECURITY S.A. - SIN SINDICATO", description: "INMOBILIARIA SECURITY S.A. - SIN SINDICATO")
General::BenefitGroup.find_or_create_by(code:"ISCTY-1",name: "INMOBILIARIA SECURITY S.A. - EXTENSIÓN BENEF. INMOBILIARIA", description: "INMOBILIARIA SECURITY S.A. - EXTENSIÓN BENEF. INMOBILIARIA")
General::BenefitGroup.find_or_create_by(code:"MSCTY-0",name: "MANDATOS SECURITY - SIN SINDICATO", description: "MANDATOS SECURITY - SIN SINDICATO")
General::BenefitGroup.find_or_create_by(code:"MSCTY-1",name: "MANDATOS SECURITY - SINDICATO MANDATOS", description: "MANDATOS SECURITY - SINDICATO MANDATOS")
General::BenefitGroup.find_or_create_by(code:"RSCTY-0",name: "REPRESENTACIONES SECURITY - SIN SINDICATO", description: "REPRESENTACIONES SECURITY - SIN SINDICATO")
General::BenefitGroup.find_or_create_by(code:"RSCTY-1",name: "REPRESENTACIONES SECURITY - CONVENIO TRAVEL", description: "REPRESENTACIONES SECURITY - CONVENIO TRAVEL")
General::BenefitGroup.find_or_create_by(code:"SACTY-0",name: "ADM. SERVICIOS BENEFICIOS LTDA - Trabajadores", description: "ADM. SERVICIOS BENEFICIOS LTDA - Trabajadores")
General::BenefitGroup.find_or_create_by(code:"SSC01-0",name: "INMOBILIARIA CASANUESTRA - SIN SINDICATO", description: "INMOBILIARIA CASANUESTRA - SIN SINDICATO")
General::BenefitGroup.find_or_create_by(code:"SSC01-1",name: "INMOBILIARIA CASANUESTRA - EXTENSIÓN BENEF INVERSIONES", description: "INMOBILIARIA CASANUESTRA - EXTENSIÓN BENEF INVERSIONES")
General::BenefitGroup.find_or_create_by(code:"SSC01-2",name: "INMOBILIARIA CASANUESTRA - EXTEN DE BENEF INVERSIONES FFVV", description: "INMOBILIARIA CASANUESTRA - EXTEN DE BENEF INVERSIONES FFVV")
General::BenefitGroup.find_or_create_by(code:"SSCTY-0",name: "SECURITIZADORA SECURITY - SIN SINDICATO", description: "SECURITIZADORA SECURITY - SIN SINDICATO")
General::BenefitGroup.find_or_create_by(code:"SSCTY-1",name: "SECURITIZADORA SECURITY - EXTENSIÓN BENEF INVERSIONES", description: "SECURITIZADORA SECURITY - EXTENSIÓN BENEF INVERSIONES")
General::BenefitGroup.find_or_create_by(code:"SSCTY-2",name: "SECURITIZADORA SECURITY - EXTEN DE BENEF INVERSIONES FFVV", description: "SECURITIZADORA SECURITY - EXTEN DE BENEF INVERSIONES FFVV")
General::BenefitGroup.find_or_create_by(code:"TSCTY-0",name: "TRAVEL SECURITY S.A. - SIN SINDICATO", description: "TRAVEL SECURITY S.A. - SIN SINDICATO")
General::BenefitGroup.find_or_create_by(code:"TSCTY-1",name: "TRAVEL SECURITY S.A. - CONVENIO TRAVEL", description: "TRAVEL SECURITY S.A. - CONVENIO TRAVEL")
General::BenefitGroup.find_or_create_by(code:"TXCTY-0",name: "TRAVEX - SIN SINDICATO", description: "TRAVEX - SIN SINDICATO")
General::BenefitGroup.find_or_create_by(code:"VDCTY-3",name: "VIDA - AGENTE DE VENTAS INDIVIDUAL", description: "VIDA - AGENTE DE VENTAS INDIVIDUAL")
General::BenefitGroup.find_or_create_by(code:"VDCTY-4",name: "VIDA - AGENTE CONSULTOR INDIVIDUAL", description: "VIDA - AGENTE CONSULTOR INDIVIDUAL")
General::BenefitGroup.find_or_create_by(code:"VDCTY-5",name: "VIDA - AGENTE CONSULTOR FINANCIERO", description: "VIDA - AGENTE CONSULTOR FINANCIERO")
General::BenefitGroup.find_or_create_by(code:"VDCTY-6",name: "VIDA - JEFES Y PROFESIONALES", description: "VIDA - JEFES Y PROFESIONALES")
General::BenefitGroup.find_or_create_by(code:"VDCTY-7",name: "VIDA - JEFE COMERCIAL INDIVIDUAL", description: "VIDA - JEFE COMERCIAL INDIVIDUAL")
General::BenefitGroup.find_or_create_by(code:"VDCTY-0",name: "VIDA - GERENTES / SUBGERENTES / COMERCIAL NO VENTAS / JEFE COMERCIAL PF", description: "VIDA - GERENTES / SUBGERENTES / COMERCIAL NO VENTAS / JEFE COMERCIAL PF")
General::BenefitGroup.find_or_create_by(code:"VDCTY-1",name: "VIDA - AGENTE DE VENTAS Y MANTENCIÓN CON BIENESTAR", description: "VIDA - AGENTE DE VENTAS Y MANTENCIÓN CON BIENESTAR")
General::BenefitGroup.find_or_create_by(code:"VDCTY-8",name: "VIDA - TELEVENTAS", description: "VIDA - TELEVENTAS")
General::BenefitGroup.find_or_create_by(code:"VDCTY-2",name: "VIDA - AGENTE DE VENTAS Y MANTENCIÓN SIN BIENESTAR", description: "VIDA - AGENTE DE VENTAS Y MANTENCIÓN SIN BIENESTAR")
General::BenefitGroup.find_or_create_by(code:"VDCTY-9",name: "VIDA - SINDICALIZADOS", description: "VIDA - SINDICALIZADOS")
General::BenefitGroup.find_or_create_by(code:"VDCTY-10",name: "VIDA - SUPERVISOR TELEVENTAS", description: "VIDA - SUPERVISOR TELEVENTAS")
General::BenefitGroup.find_or_create_by(code:"VDPRO-0",name: "PROTECTA - SIN SINDICATO", description: "PROTECTA - SIN SINDICATO")
General::BenefitGroup.find_or_create_by(code:"VSCTY-0",name: "VALORES SECURITY S.A.COR.BOLSA - SIN SINDICATO", description: "VALORES SECURITY S.A.COR.BOLSA - SIN SINDICATO")
General::BenefitGroup.find_or_create_by(code:"VSCTY-1",name: "VALORES SECURITY S.A.COR.BOLSA - EXTENSIÓN BENEF INVERSIONES", description: "VALORES SECURITY S.A.COR.BOLSA - EXTENSIÓN BENEF INVERSIONES")
General::BenefitGroup.find_or_create_by(code:"VSCTY-2",name: "VALORES SECURITY S.A.COR.BOLSA - EXTEN DE BENEF INVERSIONES FFVV", description: "VALORES SECURITY S.A.COR.BOLSA - EXTEN DE BENEF INVERSIONES FFVV")
#LINK
puts("******* Creando Links *******")
General::Link.find_or_create_by(
  id: 1,
  title: 'Link 1',
  url: 'http://www.google.cl'
)
General::Link.find_or_create_by(
  id: 2,
  title: 'Link 2',
  url: 'http://www.fayerwayer.cl'
)
General::Link.find_or_create_by(
  id: 3,
  title: 'Link 3',
  url: 'https://www.bancosecurity.cl/'
)
General::Link.find_or_create_by(
  id: 4,
  title: 'Link 4',
  url: 'https://personas.bancosecurity.cl/'
)
General::Link.find_or_create_by(
  id: 5,
  title: 'Link 5',
  url: 'http://www.security.cl'
)
General::Link.find_or_create_by(
  id: 6,
  title: 'Link 6',
  url: 'http://www.gmail.com'
)
#SECTION
puts("******* Creando Secciones *******")
General::Section.find_or_create_by(
  id: 1,
  title: 'Section 1',
  description: 'Descripción',
  position: 1,
  url: 'url-blablabla-1'
)
General::Section.find_or_create_by(
  id: 2,
  title: 'Section 2',
  description: 'Descripción',
  position: 2,
  url: 'url-blablabla-2')
General::Section.find_or_create_by(
  id: 3,
  title: 'Section 3',
  description: 'Descripción/',
  position: 3,
  url: 'url-blablabla-3'
)
General::Section.find_or_create_by(
  id: 4,
  title: 'Section 4',
  description: 'Descripción/',
  position: 4,
  url: 'url-blablabla-4')
General::Section.find_or_create_by(
  id: 5,
  title: 'Section 5',
  description: 'Descripción',
  position: 5,
  url: 'url-blablabla-5'
)
General::Section.find_or_create_by(
  id: 6,
  title: 'Section 6',
  description: 'Descripción',
  position: 6,
  url: 'url-blablabla-6')
General::Section.find_or_create_by(
  id:7,
  title: 'Section 7',
  description: 'Descripción',
  position: 7,
  url: 'url-blablabla-7'
)