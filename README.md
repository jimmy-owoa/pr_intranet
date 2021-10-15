# README

* Correr datos de prueba
    ~~~
    rake demo:data_test
    ~~~

Script cargar usuarios
~~~rb
data = JSON.parse(File.read("public/compass_users.json")); nil
count = data.count

data.each_with_index do |user, i|
  next unless user["email"].present?
  puts "====== Quedan #{count - i} usuarios por cargar ======="
  puts "Cargando usuario: #{user["email"]}"
  hash = {}
  hash[:email] = user["email"]
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
~~~