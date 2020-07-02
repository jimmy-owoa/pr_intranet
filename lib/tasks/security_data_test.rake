
namespace :security do
  task data_test: :environment do
    puts("/////////// Inicio carga de datos de prueba para security ///////////")
    puts("******* Creando Links *******")
    General::Link.where(id: 1, title: "Link 1", url: "http://www.google.cl").first_or_create
    General::Link.where(id: 2, title: "Link 2", url: "http://www.fayerwayer.cl").first_or_create
    General::Link.where(id: 3, title: "Link 3", url: "https://www.bancosecurity.cl/").first_or_create
    General::Link.where(id: 4, title: "Link 4", url: "https://personas.bancosecurity.cl/").first_or_create
    General::Link.where(id: 5, title: "Link 5", url: "http://www.security.cl").first_or_create
    General::Link.where(id: 6, title: "Link 6", url: "http://www.gmail.com").first_or_create
    puts("/////////// Fin carga de datos de prueba para security ///////////")
  end
end