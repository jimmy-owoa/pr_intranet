# ESTAODS

ExpenseReport::RequestState.where(name: 'approved' ,code: 'aprobado').first_or_create
ExpenseReport::RequestState.where(name: 'envoy' ,code: 'enviado').first_or_create
ExpenseReport::RequestState.where(name: 'attended' ,code: 'atendiendo').first_or_create
ExpenseReport::RequestState.where(name: 'closed' ,code: 'resuelto').first_or_create