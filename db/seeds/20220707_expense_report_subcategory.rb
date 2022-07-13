# Creación de Categorias

ExpenseReport::Category.where(name: 'Rendición de Gastos').first_or_create


# Crear de Subcategory

ExpenseReport::Subcategory.where(name: 'Eventos con clientes', category_id: ExpenseReport::Category.find_by(name: 'Rendición de Gastos').id).first_or_create
ExpenseReport::Subcategory.where(name: 'Viajes', category_id: ExpenseReport::Category.find_by(name: 'Rendición de Gastos').id).first_or_create
ExpenseReport::Subcategory.where(name: 'Hotel', category_id: ExpenseReport::Category.find_by(name: 'Rendición de Gastos').id).first_or_create
ExpenseReport::Subcategory.where(name: 'Uniformes', category_id: ExpenseReport::Category.find_by(name: 'Rendición de Gastos').id).first_or_create
ExpenseReport::Subcategory.where(name: 'Beneficio Personal', category_id: ExpenseReport::Category.find_by(name: 'Rendición de Gastos').id).first_or_create
ExpenseReport::Subcategory.where(name: 'Gastos Personal', category_id: ExpenseReport::Category.find_by(name: 'Rendición de Gastos').id).first_or_create
ExpenseReport::Subcategory.where(name: 'Reparaciones', category_id: ExpenseReport::Category.find_by(name: 'Rendición de Gastos').id).first_or_create
ExpenseReport::Subcategory.where(name: 'Abarrotes', category_id: ExpenseReport::Category.find_by(name: 'Rendición de Gastos').id).first_or_create
ExpenseReport::Subcategory.where(name: 'Correspondencia', category_id: ExpenseReport::Category.find_by(name: 'Rendición de Gastos').id).first_or_create
ExpenseReport::Subcategory.where(name: 'Movilización', category_id: ExpenseReport::Category.find_by(name: 'Rendición de Gastos').id).first_or_create
ExpenseReport::Subcategory.where(name: 'Subscripciones', category_id: ExpenseReport::Category.find_by(name: 'Rendición de Gastos').id).first_or_create
ExpenseReport::Subcategory.where(name: 'Notaría', category_id: ExpenseReport::Category.find_by(name: 'Rendición de Gastos').id).first_or_create
ExpenseReport::Subcategory.where(name: 'Comida de Negocios', category_id: ExpenseReport::Category.find_by(name: 'Rendición de Gastos').id).first_or_create
ExpenseReport::Subcategory.where(name: 'Regalos', category_id: ExpenseReport::Category.find_by(name: 'Rendición de Gastos').id).first_or_create
ExpenseReport::Subcategory.where(name: 'Artículos Escritorio', category_id: ExpenseReport::Category.find_by(name: 'Rendición de Gastos').id).first_or_create
ExpenseReport::Subcategory.where(name: 'Eventos Internos', category_id: ExpenseReport::Category.find_by(name: 'Rendición de Gastos').id).first_or_create
ExpenseReport::Subcategory.where(name: 'Capacitaciones', category_id: ExpenseReport::Category.find_by(name: 'Rendición de Gastos').id).first_or_create
ExpenseReport::Subcategory.where(name: 'Otros', category_id: ExpenseReport::Category.find_by(name: 'Rendición de Gastos').id).first_or_create
