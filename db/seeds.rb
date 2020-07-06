puts("******* Creando TermTypes *******")
General::TermType.find_or_create_by(name: "category")
General::TermType.find_or_create_by(name: "tag")
puts("******* Creando BenefitTypes *******")
General::BenefitType.find_or_create_by(name: "BONOS")
General::BenefitType.find_or_create_by(name: "CRÉDITOS Y SUBSIDIOS")
General::BenefitType.find_or_create_by(name: "SEGUROS")
General::BenefitType.find_or_create_by(name: "PERMISOS")
puts("******* Creando EconomicIndicatorTypes *******")
General::EconomicIndicatorType.where(name: "dolar", symbol: "US$").first_or_create
General::EconomicIndicatorType.where(name: "uf", symbol: "UF").first_or_create
puts("******* Creando Roles *******")
Role.find_or_create_by(name: "user")
Role.find_or_create_by(name: "super_admin")
Role.find_or_create_by(name: "post_admin")
puts("******* Creando Locations *******")
# REVISAR TODO
General::Location.find_or_create_by(name: "Antofagasta")
General::Location.find_or_create_by(name: "Santiago")
General::Location.find_or_create_by(name: "Copiapo")
General::Location.find_or_create_by(name: "La Serena")
General::Location.find_or_create_by(name: "Vina del Mar")
General::Location.find_or_create_by(name: "Rancagua")
General::Location.find_or_create_by(name: "Talca")
General::Location.find_or_create_by(name: "Concepcion")
General::Location.find_or_create_by(name: "Temuco")
General::Location.find_or_create_by(name: "Puerto Montt")
puts("******* Creando Usuario admin *******")
General::User.create(name: "Admin Exa", email: "admin@exaconsultores.cl", password: "exaConsultores", password_confirmation: "exaConsultores", location_id: 2, legal_number: "1", legal_number_verification: "7")
puts("******* Asignando rol Super Admin al usuario admin@exaconsultores.cl *******")
user_admin = General::User.find_by_email("admin@exaconsultores.cl")
user_admin.add_role :super_admin

# - - - - - - - - - - - - - - - USUARIOS - - - - - - - - - - - - - - -
puts("* * * * * * * Cargando Beneficios * * * * * * *")
ExaBenefitsService.perform

puts("* * * * * * * Creando Usuarios * * * * * * *")
data_users = JSON.parse(File.read("public/users_test.json"))

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
  benefit_group = General::BenefitGroup.where(name: user["grupo_beneficiario"]).first

  user_data = General::user.where(email: email).first rescue nil

  if user_data.nil?
    General::User.create(legal_number: ln_user[0...-1], legal_number_verification: ln_user[-1], email: email, name: name, last_name: last_name, position_classification: position_classification, is_boss: is_boss, rol: rol, employee_classification: employee_classification, date_entry: date_entry, birthday: birthday, civil_status: civil_status, position: position, annexed: annexed, gender: gender, favorite_name: favorite_name,company_id: company.id, benefit_group_id: benefit_group.id, office_id: office.id, location_id: 2, password: "redexa2020", password_confirmation: "redexa2020")
  end
end

General::User.all.each {|u| u.set_user_attributes }

puts("* * * * * * * Cargando Beneficios con usuarios * * * * * * *")
ExaBenefitsService.perform

# - - - - - - - - - - - - - - - NOTICIAS - - - - - - - - - - - - - - -

content = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed finibus felis felis, sed placerat nunc accumsan eu. Nullam dictum dignissim mattis. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Maecenas mollis vehicula aliquam. Mauris molestie nisl ac quam tincidunt, nec bibendum elit pharetra. Donec lacinia, arcu a fermentum vulputate, lectus augue rutrum nunc, non aliquam neque massa vel libero. Donec eget posuere mauris. Ut metus massa, vulputate id sodales vel, malesuada eu elit. Nulla facilisi. Aenean viverra sollicitudin sollicitudin. Nunc interdum leo in erat fermentum vulputate eget in est. Nam lacus nibh, faucibus id pellentesque venenatis, efficitur eget sem."

extract = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed finibus felis felis, sed placerat nunc accumsan eu. Nullam dictum dignissim mattis."

puts("* * * * * * * Creando Noticias Corporativas * * * * * * *")
10.times do |i|
  post = News::Post.where(title: "Título de Noticia corporativa #{i+1}").first rescue nil

  if post.nil?
    image_data = File.open("app/assets/images/news/news_#{i+1}.jpg")
    image = Media::Attachment.create(name: File.basename(image_data))
    image.attachment.attach(io: image_data, filename: File.basename(image_data))
    News::Post.create([
      {
        title: "Título de Noticia corporativa #{i+1}",
        extract: extract,
        content: content,
        status: "Publicado",
        user_id: 1,
        post_type: "Corporativas",
        main_image_id: image.id,
        important: true,
        profile_id: 1,
      }
    ])
  end
end
puts("* * * * * * * Creando Noticias Miscelaneos * * * * * * *")
10.times do |i|
  post = News::Post.where(title: "Título de Noticia miscelaneos #{i+1}").first rescue nil

  if post.nil?
    image_data = File.open("app/assets/images/news/news_#{i+1}.jpg")
    image = Media::Attachment.create(name: File.basename(image_data))
    image.attachment.attach(io: image_data, filename: File.basename(image_data))
    News::Post.create([
      {
        title: "Título de Noticia miscelaneos #{i+1}",
        extract: extract,
        content: content,
        status: "Publicado",
        user_id: 1,
        post_type: "Miscelaneos",
        main_image_id: image.id,
        important: false,
        profile_id: 1,
      }
    ])
  end
end
puts("* * * * * * * Creando Noticias Conociéndonos * * * * * * *")
10.times do |i|
  post = News::Post.where(title: "Título de Noticia conociéndonos #{i+1}").first rescue nil

  if post.nil?
    image_data = File.open("app/assets/images/news/news_#{i+1}.jpg")
    image = Media::Attachment.create(name: File.basename(image_data))
    image.attachment.attach(io: image_data, filename: File.basename(image_data))
    News::Post.create([
      {
        title: "Título de Noticia conociéndonos #{i+1}",
        extract: extract,
        content: content,
        status: "Publicado",
        user_id: 1,
        post_type: "Conociéndonos",
        main_image_id: image.id,
        important: false,
        profile_id: 1,
      }
    ])
  end
end

# - - - - - - - - - - - - - - - LIBROS - - - - - - - - - - - - - - - -
puts("* * * * * * * Creando Libros * * * * * * *")

categories = ["Literatura Juvenil", "Infantil", "Finanzas y economía", "Juegos de mesa"]
authors = ["J. R. R. Tolkien", "George R.R. Martin", "Val Emmich", "J. K Rowling", "Gonzalo Martinez Ortega", "Dmitry Glukhovsky"]
authors_b = ["Jose María Maza", "Disney", "Ben Brooks", "Luis Sepúlveda", "Tea Stilton", "Vegetta777 Willyrex"]
editorials = ["Minotauro", "Plaza Y Janes", "Cross Books", "Salamandra", "Planeta", "Montena"]

categories.each { |category| Library::CategoryBook.find_or_create_by(name: category) }
authors.each { |author| Library::Author.find_or_create_by(name: author) }
editorials.each { |editorial| Library::Editorial.find_or_create_by(name: editorial) }

book_titles_A = ["El silmarillion", "Una Cancion Para Lya", "Querido Evan Hansen", "Harry Potter y el Legado Maldito", "Mocha Dick: La Leyenda de la Ballena Blanca", "Metro 2035"]
book_titles_A.each_with_index do |title, i|
  book = Library::Book.where(title: title).first rescue nil
  if book.nil?
    book = Library::Book.create(title: title, description: content, edition: 1, publication_year: 2020, stock: 10, available: true, category_book_id: 1, author_id: i + 1, editorial_id: i + 1)
    image_data = File.open("app/assets/images/books/book_A#{i+1}.jpg")
    book.image.attach(io: image_data, filename: File.basename(image_data)) if book.image.attachment.nil?
  end
end

book_titles_B = ["Somos Polvo de Estrellas. Para Niños y Niñas", "Gravity Falls. Lejos de Casa", "Cuentos Para Niños que se Atreven a ser Diferentes", "Historia de Mix, de max y de mex", "Salvemos a los Animales", "Wigetta y el Antídoto Secreto"]
book_titles_B.each_with_index do |title, i|
  book = Library::Book.where(title: title).first rescue nil
  if book.nil?  
    book = Library::Book.create(title: title, description: content, edition: 1, publication_year: 2020, stock: 10, available: true, category_book_id: 2, author_id: i + 1, editorial_id: i + 1)
    image_data = File.open("app/assets/images/books/book_B#{i+1}.jpg")
    book.image.attach(io: image_data, filename: File.basename(image_data)) if book.image.attachment.nil?
  end
end

book_titles_C = ["Véndele a la Mente, no a la Gente", "Por que Fracasan los Paises", "El método del lobo de Wall Street", "Piensa al Revés", "20 Filósofos Visitan su Empresa", "El poder del click"]
book_titles_C.each_with_index do |title, i|
  book = Library::Book.where(title: title).first rescue nil
  if book.nil?
    image_data = File.open("app/assets/images/books/book_C#{i+1}.jpg")
    book = Library::Book.create(title: title, description: content, edition: 1, publication_year: 2020, stock: 10, available: true, category_book_id: 3, author_id: i + 1, editorial_id: i + 1)
    book.image.attach(io: image_data, filename: File.basename(image_data)) if book.image.attachment.nil?
  end
end

# - - - - - - - - - - - NACIMIENTOS - - - - - - - - - - - - - - -
puts("* * * * * * * Creando Nacimientos * * * * * * *")
birth_names = ["Felipe", "Juan", "Nicolás", "Andrés", "Sebastián", "Carlos"]
birth_lastnames = ["Pérez", "Gutierrez", "Baeza", "Morales", "Saavedra", "Pinto"]
birth_lastnames_2 = ["Zamorano", "Abarca", "Molina", "López", "Diaz", "Ramirez"]

6.times do |i|
  birth = Employee::Birth.find(i+1) rescue nil
  if birth.nil?
    birth = Employee::Birth.create(id: i+1, child_name: birth_names[i], child_lastname: birth_lastnames[i], child_lastname2: birth_lastnames_2[i], approved: true, gender: true, is_public: true, user_id: i+2, birthday: Date.new(2020, 1, 6))
    image_data = File.open("app/assets/images/nacimiento.jpg")
    birth.photo.attach(io: image_data, filename: File.basename(image_data))
    birth.photo.attachment.update(permission: 1)
  end
end

births_date_today = Employee::Birth.where(birthday: Date.today)
if births_date_today.empty?
  6.times do |i|    
    birth = Employee::Birth.create(child_name: birth_names[i], child_lastname: birth_lastnames[i], child_lastname2: birth_lastnames_2[i], approved: true, gender: true, is_public: true, user_id: i+2, birthday: Date.today)
    image_data = File.open("app/assets/images/nacimiento.jpg")
    birth.photo.attach(io: image_data, filename: File.basename(image_data))
    birth.photo.attachment.update(permission: 1)
  end
end

# - - - - - - - - - - - PRODUCTOS - - - - - - - - - - - - - - -
puts("* * * * * * * Creando Productos * * * * * * *")
user_product = General::User.find(10)

products_type_1 = Marketplace::Product.where(product_type: "Autos")
if products_type_1.empty?
  6.times do |i|
    product = Marketplace::Product.create(name: "Producto Automóvil#{i+1}", description: content, product_type: "Autos", price: 7000000, email: user_product.email, phone: "+561234", location: "Av. 23, Santiago", approved: true, user_id: user_product.id, currency: "$")
    image_data = File.open("app/assets/images/products/car_#{i+1}.jpg")
    product.images.attach(io: image_data, filename: File.basename(image_data))
    product.images.attachments.update(permission: 1)
  end
end

products_type_2 = Marketplace::Product.where(product_type: "Propiedades")
if products_type_2.empty?
  6.times do |i|
    product = Marketplace::Product.create(name: "Producto Propiedad #{i+1}", description: content, product_type: "Propiedades", price: 3000, email: user_product.email, phone: "+561234", location: "Av. 23, Santiago", approved: true, user_id: user_product.id, currency: "UF")
    image_data = File.open("app/assets/images/products/house_#{i+1}.jpg")
    product.images.attach(io: image_data, filename: File.basename(image_data))
    product.images.attachments.update(permission: 1)
  end
end

# - - - - - - - - - - - ENCUESTAS - - - - - - - - - - - - - - -
puts("* * * * * * * Creando Encuestas * * * * * * *")
question_type = ["Múltiple", "Simple", "Verdadero o Falso", "Texto", "Número", "Selección", "Escala lineal"]

surveys = Survey::Survey.count

if surveys == 0
  7.times do |i|
    survey = Survey::Survey.create(name: "Encuesta General #{i+1}", description: content, status: "Publicado", profile_id: 1)
    image_data = File.open("app/assets/images/surveys/survey_#{i+1}.jpg")
    survey.image.attach(io: image_data, filename: File.basename(image_data))
    7.times do |j|
      question = Survey::Question.create(title: "Pregunta #{j+1}", question_type: question_type[j], optional: true, survey_id: survey.id)
      4.times do |k|
        if question.question_type == "Múltiple" || question.question_type == "Simple" || question.question_type == "Selección" 
          option = Survey::Option.create(title: "Opción #{k+1}", question_id: question.id)
        end
      end
    end
  end
end