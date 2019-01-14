#term type
General::TermType.create(name: 'category')
General::TermType.create(name: 'tag')
#terms
General::Term.create(name: 'Banco', term_type_id: 1)
General::Term.create(name: 'Factoring', term_type_id: 1)
General::Term.create(name: 'Inversiones', term_type_id: 1)
General::Term.create(name: 'Vida', term_type_id: 1)
General::Term.create(name: 'Corredora de Seguros', term_type_id: 1)
General::Term.create(name: 'Travel', term_type_id: 1)
General::Term.create(name: 'Inmobiliaria', term_type_id: 1)
#roles
Role.create(name: 'user')
Role.create(name: 'super_admin')
#users
General::User.create(
  name:'Nombre',
  last_name: 'Apellido',
  annexed: '1029',
  email: 'admin@security.cl',
  password: 'security',
  birthday: Date.today,
)
General::User.create(
  name:'Nombre 2',
  last_name: 'Apellido 2',
  annexed: '1928',
  email: 'user@security.cl',
  password: 'security',
  birthday: Date.today-1
)
General::User.create(
  name:'Persona 3',
  last_name: 'a cargo de',
  annexed: '11020',
  email: 'a-cargo-de@security.cl',
  password: 'security',
  birthday: Date.today-2,
)
General::User.create(
  name:'Persona 4',
  last_name: 'rama',
  annexed: '22212',
  email: 'otro-a-cargode@security.cl',
  password: 'security',
  birthday: Date.today-2,
)
#users / user_admin see admin screen and user see welcome screen
user_admin = General::User.find(1)
user_admin.image.attach(io: File.open("app/assets/images/user1.png"), filename: "user1.png", content_type: "image/png")
user = General::User.find(2)
user.image.attach(io: File.open("app/assets/images/user1.png"), filename: "user1.png", content_type: "image/png")
#add roles to user - 
user_admin.add_role :super_admin
user.add_role :user
#economic indicators
General::EconomicIndicatorType.create(name: 'dolar', symbol: 'US$') #1
General::EconomicIndicatorType.create(name: 'euro', symbol: '€') #2
General::EconomicIndicatorType.create(name: 'uf', symbol:'UF' ) #3
General::EconomicIndicatorType.create(name: 'utm', symbol: 'UTM') #4
General::EconomicIndicatorType.create(name: 'ipc', symbol: 'IPC') #5
#post
News::Post.create(
  title: '¡Gravísimo! Facebook traficó con tus mensajes privados de forma grotesca con otras compañías', 
  slug: 'Slug', 
  content: '¡Netflix, Spotify y varias firmas involucradas en serio caso! Facebook superándose a sí mismo, una vez más.', visibility: "Público", 
  post_class: "tipo", 
  user_id: 1
)
News::Post.create(
  title: 'Observatorio de Rayos Gamma más potente del mundo se instalará en Chile', 
  slug: 'Slug', 
  content: 'En el proyecto participarán diversas instituciones nacionales e internacionales y permitirá la instalación de este potente observatorio de Rayos Gamma.', 
  visibility: "Público", 
  post_class: "tipo", 
  user_id: 1
)
News::Post.create(
  title: 'Elon Musk y The Boring Company muestran su sistema de túneles en acción', 
  slug: 'Slug', 
  content: 'The Boring Company abrió su primera línea de transporte para que los mortales conozcamos el futuro del desplazamiento.',visibility: "Público", 
  post_class: "tipo", 
  user_id: 1
)
#esto no funciona, manda error en el main_image_id( que no lo agregué en el create del post)
# News::Post.first.main_image.attach(io: File.open("app/assets/images/post_news.png"), filename: "post_news.png", content_type: "image/png")
#product and image
Marketplace::Product.create(
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
)
Marketplace::Product.last.images.attach(io: File.open("app/assets/images/auto1.png"), filename: "auto1.png", content_type: "image/png")
#birth
Employee::Birth.create(full_name_mother: "mamá nacido",
  full_name_father: "papá nacido",
  child_name: "nombre nacido",
  child_lastname: "apellido nacido",
  approved: true,
  gender: true,
  birthday: Date.today
)
Employee::Birth.last.photo.attach(io: File.open("app/assets/images/guagua.jpg"), filename: "auto1.jpg", content_type: "image/jpg")
#Menus
General::Menu.create( 
  title: "Bienvenidos",
  description: "Listar los usuarios que llegaron a la empresa",
  css_class: "#545454",
  code: 1223,
  link: "bienvenidos",
  priority: nil,
  parent_id: nil
)
General::Menu.create( 
  title: "Nacimientos",
  description: "Listar los hij@s de los empleados de la empresa",
  css_class: "000001",
  code: 1224,
  link: "nacimientos",
  priority: nil,
  parent_id: nil
)
General::Menu.create( 
  title: "Crear Nacimientos",
  description: "Crear nacimiento",
  css_class: "#ff00d5",
  code: 1225,
  link: "nacimientos/create",
  priority: nil,
  parent_id: nil
)
General::Menu.create( 
  title: "Cumpleanos",
  description: "Listas cumpleaños de los empleados",
  css_class: "#00ffbb",
  code: 1226,
  link: "cumpleaños",
  priority: nil,
  parent_id: nil
)
General::Menu.create(
  title: "Productos",
  description: "Listas productos",
  css_class: "#000000",
  code: 1227,
  link: "avisos",
  priority: nil,
  parent_id: nil
)
General::Menu.create(
  title: "Encuestas",
  description: "Listas encuestas",
  css_class: "#e3e3e3",
  code: 1228,
  link: "encuestas",
  priority: nil,
  parent_id: nil
)
General::Menu.create(
  title: "Noticias",
  description: "Listas de posts / noticias",
  css_class: "#744db8",
  code: 1229,
  link: "noticias",
  priority: nil,
  parent_id: nil
)
#surveys
Survey::Survey.create(name: 'Encuesta de las ciudades de Chile')
Survey::Question.create( title: "¿Cual es la ciudad más linda de Chile?", description: "Encuesta para saber cual es la ciudad favorita de los usuarios.", question_type: "Simple", survey_id: 1)
Survey::Option.create(title: "Arica", default: true, placeholder: "", question_id: 1)
Survey::Option.create(title: "Calama", default: false, placeholder: "", question_id: 1)
Survey::Option.create(title: "Coquimbo", default: false, placeholder: "", question_id: 1)
Survey::Option.create(title: "Puerto Montt", default: false, placeholder: "", question_id: 1)
Survey::Option.create(title: "Punta Arenas", default: false, placeholder: "", question_id: 1)
#cities
10.times do |city|
  General::WeatherInformation.create(
    location: 'Copiapo', 
    date: Date.today,
    current_temp: "21",
    condition: "Partly cloudy",
    icon: "//cdn.apixu.com/weather/64x64/day/116.png",
    max_temp: "27.4",
    min_temp: "12.8",
  )
end
