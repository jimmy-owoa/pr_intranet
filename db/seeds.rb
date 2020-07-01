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


# - - - - - - - - - - - - - - - NOTICIAS - - - - - - - - - - - - - - -

content = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed finibus felis felis, sed placerat nunc accumsan eu. Nullam dictum dignissim mattis. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Maecenas mollis vehicula aliquam. Mauris molestie nisl ac quam tincidunt, nec bibendum elit pharetra. Donec lacinia, arcu a fermentum vulputate, lectus augue rutrum nunc, non aliquam neque massa vel libero. Donec eget posuere mauris. Ut metus massa, vulputate id sodales vel, malesuada eu elit. Nulla facilisi. Aenean viverra sollicitudin sollicitudin. Nunc interdum leo in erat fermentum vulputate eget in est. Nam lacus nibh, faucibus id pellentesque venenatis, efficitur eget sem."

extract = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed finibus felis felis, sed placerat nunc accumsan eu. Nullam dictum dignissim mattis."

puts("* * * * * * * Eliminando noticias * * * * * * *")
News::Post.destroy_all

puts("* * * * * * * Creando Noticias Corporativas * * * * * * *")
10.times do |i|
  image_data = File.open("app/assets/images/news/news_#{i+1}.jpg")
  image = Media::Attachment.create(name: File.basename(image_data))
  image.attachment.attach(io: image_data, filename: File.basename(image_data))
  post = News::Post.create([
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
puts("* * * * * * * Creando Noticias Miscelaneos * * * * * * *")
10.times do |i|
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
puts("* * * * * * * Creando Noticias Conociéndonos * * * * * * *")
10.times do |i|
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

# - - - - - - - - - - - - - - - LIBROS - - - - - - - - - - - - - - - - 