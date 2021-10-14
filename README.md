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
  email = user["email"]
  puts "Cargando usuario: #{email}"
  id_exa = user["id_exa"]
  legal_number = user["legal_number"]
  name = user["name"]
  last_name = user["last_name"]
  last_name2 = user["last_name2"]
  position = user["cargo"]
  id_exa_boss = user["id_exa_boss"]
  office_address = user["office_address"]
  country = Location::Country.where(name: office_address).first_or_create
  record = General::User.find_by(id_exa: id_exa)
  if(record.present?)
    puts "Usuario a actualizar. ID: #{record.id} - EMAIL: #{record.email}"
    if record.update(email: email, id_exa: id_exa, legal_number: legal_number, name: name, last_name: last_name, last_name2: last_name2, position: position, id_exa_boss: id_exa_boss, country: country)
      puts "Actualizado correctamente."
    else
      puts "Error: #{record.errors}"
    end
  else
    General::User.create!(email: email, id_exa: id_exa, legal_number: legal_number, name: name, last_name: last_name, last_name2: last_name2, position: position, id_exa_boss: id_exa_boss, country: country)
    puts "++Usuario creado. EMAIL: #{email}"
  end
end
~~~