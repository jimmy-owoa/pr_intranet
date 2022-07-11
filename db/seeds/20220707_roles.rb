# Creacipon de roles por paises

Location::Country.all.each do |country|
  Role.where(name: country.name, resource_type: 'Location::Country', resource_id: country.id).first_or_create
end