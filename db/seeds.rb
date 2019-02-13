def es_bisiesto?(year)
  year % 4 == 0 && year % 100 != 0 || year % 400 == 0
end
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
Role.create(name: 'post_admin')
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
# user_admin.image.attach(io: File.open("app/assets/images/user1.png"), filename: "user1.png", content_type: "image/png")
user = General::User.find(2)
# user.image.attach(io: File.open("app/assets/images/user1.png"), filename: "user1.png", content_type: "image/png")
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
# Marketplace::Product.last.images.attach(io: File.open("app/assets/images/auto1.png"), filename: "auto1.png", content_type: "image/png")
#birth
Employee::Birth.create(full_name_mother: "mamá nacido",
  full_name_father: "papá nacido",
  child_name: "nombre nacido",
  child_lastname: "apellido nacido",
  approved: true,
  gender: true,
  birthday: Date.today
)
# Employee::Birth.last.photo.attach(io: File.open("app/assets/images/guagua.jpg"), filename: "auto1.jpg", content_type: "image/jpg")
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
  title: "Crear avisos",
  description: "Crear Avisos",
  css_class: "#1e5755",
  code: 1231,
  link: "avisos/create",
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
General::Menu.create(
  title: "Faq",
  description: "preguntas y respuestas",
  css_class: "#db9377",
  code: 1230,
  link: "preguntas-frecuentes",
  priority: nil,
  parent_id: nil
)
#menú nuevo
#->Vacaciones
General::Menu.create(
  title: "Vacaciones",
  description: "Vacaciones Security",
  css_class: "#000000",
  code: 1231,
  link: "vacaciones",
  priority: nil,
  parent_id: nil
)
General::Menu.create(
  title: "Solicitudes",
  description: "Solicitudes",
  css_class: "#db9398",
  code: 1232,
  link: "solicitudes",
  priority: nil,
  parent_id: 10
)
General::Menu.create(
  title: "Aprobación",
  description: "Aprobación",
  css_class: "#db9398",
  code: 1233,
  link: "aprobacion",
  priority: nil,
  parent_id: 10
)
General::Menu.create(
  title: "Vacaciones progresivas",
  description: "Vacaciones progresivas",
  css_class: "#db3562",
  code: 1234,
  link: "vacaciones-progresivas",
  priority: nil,
  parent_id: 10
)
#->Noticias
General::Menu.create(
  title: "Noticias",
  description: "Noticias",
  css_class: "#b13362",
  code: 1235,
  link: "",
  priority: nil,
  parent_id: nil
)
General::Menu.create(
  title: "Corporativas",
  description: "corporativas",
  css_class: "#b13362",
  code: 1236,
  link: "corporativas",
  priority: nil,
  parent_id: 14
)
General::Menu.create(
  title: "Miscelanias",
  description: "Miscelanias",
  css_class: "#b10312",
  code: 1237,
  link: "miscelanias",
  priority: nil,
  parent_id: 14
)
General::Menu.create(
  title: "Conociéndonos",
  description: "Conociéndonos",
  css_class: "#a15293",
  code: 1238,
  link: "conociendonos",
  priority: nil,
  parent_id: 14
)
#->Mis beneficios(Conocer)
General::Menu.create(
  title: "Bono Auxiliar de Párvulo Materno",
  description: "Bono Auxiliar de Párvulo Materno",
  css_class: "#y32571",
  code: 1239,
  link: "bono-auxiliar-parvulo-materno",
  priority: nil,
  parent_id: nil
)
General::Menu.create(
  title: "Bono Auxiliar de Párvulo Paterno",
  description: "Bono Auxiliar de Párvulo Paterno",
  css_class: "#366s12",
  code: 1240,
  link: "bono-auxiliar-parvulo-paterno",
  priority: nil,
  parent_id: 18
)
General::Menu.create(
  title: "Bono de Fallecimiento",
  description: "Bono de Fallecimiento",
  css_class: "#109220",
  code: 1241,
  link: "bono-fallecimiento",
  priority: nil,
  parent_id: 18
)
General::Menu.create(
  title: "Bono de Matrimonio",
  description: "Bono de Matrimonio",
  css_class: "#b2310o",
  code: 1242,
  link: "bono-de-matrimonio",
  priority: nil,
  parent_id: 18
)
General::Menu.create(
  title: "Bono de Navidad",
  description: "Bono de Navidad",
  css_class: "#a81000",
  code: 1243,
  link: "bono-navidad",
  priority: nil,
  parent_id: 18
)
General::Menu.create(
  title: "Aguinaldo Fiestas Patrias",
  description: "Aguinaldo Fiestas Patrias",
  css_class: "#a12203",
  code: 1244,
  link: "aguinaldo-fiestas-patrias",
  priority: nil,
  parent_id: 18
)

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