puts("******* Creando TermTypes *******")
General::TermType.find_or_create_by(name: 'category')
General::TermType.find_or_create_by(name: 'tag')
puts("******* Creando BenefitTypes *******")
General::BenefitType.find_or_create_by(name: 'BONOS')
General::BenefitType.find_or_create_by(name: 'CRÉDITOS Y SUBSIDIOS')
General::BenefitType.find_or_create_by(name: 'SEGUROS')
puts("******* Creando EconomicIndicatorTypes *******")
General::EconomicIndicatorType.where(name: 'dolar', symbol: 'US$').first_or_create
General::EconomicIndicatorType.where(name: 'uf', symbol:'UF' ).first_or_create 
puts("******* Creando Roles *******")
Role.find_or_create_by(name: 'user')
Role.find_or_create_by(name: 'super_admin')
Role.find_or_create_by(name: 'post_admin')
puts("******* Creando Locations *******")
# REVISAR TODO
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
puts("******* Creando Usuario admin *******")
General::User.create(name: 'Admin Exa', email: 'admin@exaconsultores.cl', password: 'exaConsultores', password_confirmation: 'exaConsultores', location_id: 2)
puts("******* Asignando rol Super Admin al usuario admin@exaconsultores.cl *******")
user_admin = General::User.first
user_admin.add_role :super_admin