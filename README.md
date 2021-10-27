# README

* Correr datos de prueba
    ~~~
    rake demo:data_test
    ~~~

Script cargar usuarios
~~~rb
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
~~~

Subir archivo al servidor:
~~~
scp ./public/compass_users.json ssh ubuntu@18.233.138.39:~/compass-helpcenter/current/public
~~~