General::TermType.create(name: 'category')
General::TermType.create(name: 'tag')
General::Term.create(name: 'Banco', term_type_id: 1)
General::Term.create(name: 'Factoring', term_type_id: 1)
General::Term.create(name: 'Inversiones', term_type_id: 1)
General::Term.create(name: 'Vida', term_type_id: 1)
General::Term.create(name: 'Corredora de Seguros', term_type_id: 1)
General::Term.create(name: 'Travel', term_type_id: 1)
General::Term.create(name: 'Inmobiliaria', term_type_id: 1)
Role.create(name: 'user')
Role.create(name: 'super_admin')
General::User.create(name:'Nombre', last_name: 'Apellido', annexed: '1029', email: 'admin@security.cl', password: 'security', birthday: Date.today)
General::User.create(name:'Nombre 2', last_name: 'Apellido 2', annexed: '1928', email: 'user@security.cl', password: 'security', birthday: Date.today-1)
#users / user_admin see admin screen and user see welcome screen
user_admin = General::User.find_by_email('admin@security.cl')
user = General::User.find_by_email('user@security.cl')
#add roles to user - 
user_admin.add_role :super_admin
user.add_role :user
General::EconomicIndicatorType.create(name: 'dolar', symbol: 'US$') #1
General::EconomicIndicatorType.create(name: 'euro', symbol: '€') #2
General::EconomicIndicatorType.create(name: 'uf', symbol:'UF' ) #3
General::EconomicIndicatorType.create(name: 'utm', symbol: 'UTM') #4
General::EconomicIndicatorType.create(name: 'ipc', symbol: 'IPC') #5

