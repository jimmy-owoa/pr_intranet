# ESTAODS

ExpenseReport::RequestState.where(name: 'open' ,code: 'abierto').first_or_create
ExpenseReport::RequestState.where(name: 'awaiting approval' ,code: 'en revisión').first_or_create
ExpenseReport::RequestState.where(name: 'attended' ,code: 'atendiendo').first_or_create
ExpenseReport::RequestState.where(name: 'closed' ,code: 'resuelto').first_or_create