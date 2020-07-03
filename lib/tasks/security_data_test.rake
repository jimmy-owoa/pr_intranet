
namespace :security do
  task data_test: :environment do
    puts("/////////// Inicio carga de datos de prueba para security ///////////")

    # - - - - - - - - - - LINKS - - - - - - - - - -
    puts("******* Creando Links *******")
    
    image_link_1 = File.open("app/assets/images/links/link_1.jpg")
    link_1 = General::Link.where(id: 1, title: "Link 1", url: "http://www.google.cl").first_or_create
    link_1.image.attach(io: image_link_1, filename: File.basename(image_link_1)) if link_1.image.attachment.nil?

    image_link_2 = File.open("app/assets/images/links/link_2.jpg")
    link_2 = General::Link.where(id: 2, title: "Link 2", url: "http://www.fayerwayer.cl").first_or_create
    link_2.image.attach(io: image_link_2, filename: File.basename(image_link_2)) if link_2.image.attachment.nil?

    image_link_3 = File.open("app/assets/images/links/link_3.jpg")
    link_3 = General::Link.where(id: 3, title: "Link 3", url: "https://www.bancosecurity.cl/").first_or_create
    link_3.image.attach(io: image_link_3, filename: File.basename(image_link_3)) if link_3.image.attachment.nil?

    image_link_4 = File.open("app/assets/images/links/link_4.jpg")
    link_4 = General::Link.where(id: 4, title: "Link 4", url: "https://personas.bancosecurity.cl/").first_or_create
    link_4.image.attach(io: image_link_4, filename: File.basename(image_link_4)) if link_4.image.attachment.nil?

    image_link_5 = File.open("app/assets/images/links/link_5.jpg")
    link_5 = General::Link.where(id: 5, title: "Link 5", url: "http://www.security.cl").first_or_create
    link_5.image.attach(io: image_link_5, filename: File.basename(image_link_5)) if link_5.image.attachment.nil?

    image_link_6 = File.open("app/assets/images/links/link_6.jpg")
    link_6 = General::Link.where(id: 6, title: "Link 6", url: "http://www.gmail.com").first_or_create
    link_6.image.attach(io: image_link_6, filename: File.basename(image_link_6)) if link_6.image.attachment.nil?

    # - - - - - - - - - - SECCIONES - - - - - - - - - -
    puts("******* Creando Secciones *******")
    General::Section.find_or_create_by(title: "Conociéndonos", description: "Esta es la descripción de la sección", position: 1, url: "url-blablabla-1")

    section_2 = General::Section.find_or_create_by(title: "Conoce mi área", description: "Esta es la descripción de la sección", position: 2, url: "url-blablabla-1")
    image_section_2 = File.open("app/assets/images/sections/oportunidades.jpg")
    section_2.image.attach(io: image_section_2, filename: File.basename(image_section_2))

    section_3 = General::Section.find_or_create_by(title: "Beneficios", description: "Esta es la descripción de la sección", position: 3, url: "beneficios")
    image_section_3 = File.open("app/assets/images/sections/beneficios.jpg")
    section_3.image.attach(io: image_section_3, filename: File.basename(image_section_3))

    section_4 = General::Section.find_or_create_by(title: "Biblioteca", description: "Esta es la descripción de la sección/", position: 4, url: "biblioteca")
    image_section_4 = File.open("app/assets/images/sections/biblioteca.jpg")
    section_4.image.attach(io: image_section_4, filename: File.basename(image_section_4))

    section_5 = General::Section.find_or_create_by(title: "Avisos Clasificados", description: "Esta es la descripción de la sección", position: 5, url: "avisos-clasificados")
    image_section_5 = File.open("app/assets/images/sections/avisos_clasificados.jpg")
    section_5.image.attach(io: image_section_5, filename: File.basename(image_section_5))

    puts("/////////// Fin carga de datos de prueba para security ///////////")
  end
end