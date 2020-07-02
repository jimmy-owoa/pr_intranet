namespace :security do
  desc "Generate default data for Security Group"
  task install: :environment do
    def es_bisiesto?(year)
      year % 4 == 0 && year % 100 != 0 || year % 400 == 0
    end

    puts("/////////// Inicio carga de datos base para security ///////////")
    puts("******* Creando EconomicIndicatorTypes *******")
    General::EconomicIndicatorType.where(name: "dolar", symbol: "US$").first_or_create #1
    General::EconomicIndicatorType.where(name: "euro", symbol: "€").first_or_create #2
    General::EconomicIndicatorType.where(name: "uf", symbol: "UF").first_or_create #3
    General::EconomicIndicatorType.where(name: "utm", symbol: "UTM").first_or_create #4
    General::EconomicIndicatorType.where(name: "ipc", symbol: "IPC").first_or_create #5
    General::EconomicIndicatorType.where(name: "ipsa", symbol: "SPCLXIPSA").first_or_create #6
    puts("******* Creando Roles message_admin y benefit_admin *******")
    Role.find_or_create_by(name: "message_admin")
    Role.find_or_create_by(name: "benefit_admin")
    puts("******* Creando Santorales *******")
    extra_post = News::Post.where(post_type: "Conociéndonos").first

    puts("******* Creando Santorales *******")
    General::Santoral.find_or_create_by(name: "María, Madre de Dios", santoral_day: "01-01")
    General::Santoral.find_or_create_by(name: "Basilio, Gregorio", santoral_day: "01-02")
    General::Santoral.find_or_create_by(name: "Genoveva", santoral_day: "01-03")
    General::Santoral.find_or_create_by(name: "Yolando, Rigoberto", santoral_day: "01-04")
    General::Santoral.find_or_create_by(name: "Emilia", santoral_day: "01-05")
    General::Santoral.find_or_create_by(name: "Wilma, Melanio", santoral_day: "01-06")
    General::Santoral.find_or_create_by(name: "Raimundo", santoral_day: "01-07")
    General::Santoral.find_or_create_by(name: "Luciano, Eladio", santoral_day: "01-08")
    General::Santoral.find_or_create_by(name: "Lucrecia", santoral_day: "01-09")
    General::Santoral.find_or_create_by(name: "Gonzalo", santoral_day: "01-10")
    General::Santoral.find_or_create_by(name: "Alejandro", santoral_day: "01-11")
    General::Santoral.find_or_create_by(name: "Julián", santoral_day: "01-12")
    General::Santoral.find_or_create_by(name: "Hilario", santoral_day: "01-13")
    General::Santoral.find_or_create_by(name: "Félix", santoral_day: "01-14")
    General::Santoral.find_or_create_by(name: "Raquel, Mauro", santoral_day: "01-15")
    General::Santoral.find_or_create_by(name: "Marcelo", santoral_day: "01-16")
    General::Santoral.find_or_create_by(name: "Antonio, Guido", santoral_day: "01-17")
    General::Santoral.find_or_create_by(name: "Prisca - Priscila", santoral_day: "01-18")
    General::Santoral.find_or_create_by(name: "Mario", santoral_day: "01-19")
    General::Santoral.find_or_create_by(name: "Sebastián, Fabián", santoral_day: "01-20")
    General::Santoral.find_or_create_by(name: "Inés", santoral_day: "01-21")
    General::Santoral.find_or_create_by(name: "Laura Vicuña, Vicente", santoral_day: "01-22")
    General::Santoral.find_or_create_by(name: "Virginia", santoral_day: "01-23")
    General::Santoral.find_or_create_by(name: "Francisco de Sales", santoral_day: "01-24")
    General::Santoral.find_or_create_by(name: "Elvira", santoral_day: "01-25")
    General::Santoral.find_or_create_by(name: "Timoteo, Tito, Paula - Paola", santoral_day: "01-26")
    General::Santoral.find_or_create_by(name: "Ángela Merici", santoral_day: "01-27")
    General::Santoral.find_or_create_by(name: "Tomás de Aquino", santoral_day: "01-28")
    General::Santoral.find_or_create_by(name: "Valerio Martina", santoral_day: "01-29")
    General::Santoral.find_or_create_by(name: "Martina de Roma", santoral_day: "01-30")
    General::Santoral.find_or_create_by(name: "Juan Bosco, Marcela", santoral_day: "01-31")
    General::Santoral.find_or_create_by(name: "Severiano", santoral_day: "02-01")
    General::Santoral.find_or_create_by(name: "Presentación del Señor", santoral_day: "02-02")
    General::Santoral.find_or_create_by(name: "Blas, Oscar", santoral_day: "02-03")
    General::Santoral.find_or_create_by(name: "Gilberto", santoral_day: "02-04")
    General::Santoral.find_or_create_by(name: "Agueda", santoral_day: "02-05")
    General::Santoral.find_or_create_by(name: "Doris, Pablo Miki", santoral_day: "02-06")
    General::Santoral.find_or_create_by(name: "Gastón", santoral_day: "02-07")
    General::Santoral.find_or_create_by(name: "Jerónimo Emiliano, Jacqueline", santoral_day: "02-08")
    General::Santoral.find_or_create_by(name: "Rebeca", santoral_day: "02-09")
    General::Santoral.find_or_create_by(name: "Escolástica", santoral_day: "02-10")
    General::Santoral.find_or_create_by(name: "N.Sra. de Lourdes", santoral_day: "02-11")
    General::Santoral.find_or_create_by(name: "Panfilio, Pamela", santoral_day: "02-12")
    General::Santoral.find_or_create_by(name: "Batriz", santoral_day: "02-13")
    General::Santoral.find_or_create_by(name: "Cirilo, Metodio, Valentino", santoral_day: "02-14")
    General::Santoral.find_or_create_by(name: "Fausto-ino, Jovita", santoral_day: "02-15")
    General::Santoral.find_or_create_by(name: "Samuel", santoral_day: "02-16")
    General::Santoral.find_or_create_by(name: "Alexis", santoral_day: "02-17")
    General::Santoral.find_or_create_by(name: "Bernardita", santoral_day: "02-18")
    General::Santoral.find_or_create_by(name: "Álvaro", santoral_day: "02-19")
    General::Santoral.find_or_create_by(name: "Eleuterio, Claudio", santoral_day: "02-20")
    General::Santoral.find_or_create_by(name: "Pedro Daminán, Severino", santoral_day: "02-21")
    General::Santoral.find_or_create_by(name: "Eleonora, Nora", santoral_day: "02-22")
    General::Santoral.find_or_create_by(name: "Florencio", santoral_day: "02-23")
    General::Santoral.find_or_create_by(name: "Rubén, Sergio", santoral_day: "02-24")
    General::Santoral.find_or_create_by(name: "Néstor", santoral_day: "02-25")
    General::Santoral.find_or_create_by(name: "Augusto", santoral_day: "02-26")
    General::Santoral.find_or_create_by(name: "Leandro, Gabriel Dol", santoral_day: "02-27")
    General::Santoral.find_or_create_by(name: "Román", santoral_day: "02-28")
    General::Santoral.find_or_create_by(name: "Bisiesto", santoral_day: "02-29") if es_bisiesto?(Date.today.year)
    General::Santoral.find_or_create_by(name: "Rosendo", santoral_day: "03-01")
    General::Santoral.find_or_create_by(name: "Lucio", santoral_day: "03-02")
    General::Santoral.find_or_create_by(name: "Celedonio", santoral_day: "03-03")
    General::Santoral.find_or_create_by(name: "Ariel", santoral_day: "03-04")
    General::Santoral.find_or_create_by(name: "Olivia", santoral_day: "03-05")
    General::Santoral.find_or_create_by(name: "Elcira", santoral_day: "03-06")
    General::Santoral.find_or_create_by(name: "Perpétua, Felicidad", santoral_day: "03-07")
    General::Santoral.find_or_create_by(name: "Juan de Dios", santoral_day: "03-08")
    General::Santoral.find_or_create_by(name: "Francisca Romana", santoral_day: "03-09")
    General::Santoral.find_or_create_by(name: "Macario", santoral_day: "03-10")
    General::Santoral.find_or_create_by(name: "Eulogio", santoral_day: "03-11")
    General::Santoral.find_or_create_by(name: "Norma", santoral_day: "03-12")
    General::Santoral.find_or_create_by(name: "Rodrigo", santoral_day: "03-13")
    General::Santoral.find_or_create_by(name: "Matilde", santoral_day: "03-14")
    General::Santoral.find_or_create_by(name: "Luisa de Marillac", santoral_day: "03-15")
    General::Santoral.find_or_create_by(name: "Heriberto", santoral_day: "03-16")
    General::Santoral.find_or_create_by(name: "Patricio", santoral_day: "03-17")
    General::Santoral.find_or_create_by(name: "Cirilo", santoral_day: "03-18")
    General::Santoral.find_or_create_by(name: "José", santoral_day: "03-19")
    General::Santoral.find_or_create_by(name: "Alejandra", santoral_day: "03-20")
    General::Santoral.find_or_create_by(name: "Eugenia", santoral_day: "03-21")
    General::Santoral.find_or_create_by(name: "Lea", santoral_day: "03-22")
    General::Santoral.find_or_create_by(name: "Dimas", santoral_day: "03-23")
    General::Santoral.find_or_create_by(name: "Elba, Catalina de Suecia", santoral_day: "03-24")
    General::Santoral.find_or_create_by(name: "Anunciación", santoral_day: "03-25")
    General::Santoral.find_or_create_by(name: "Braulio", santoral_day: "03-26")
    General::Santoral.find_or_create_by(name: "Ruperto", santoral_day: "03-27")
    General::Santoral.find_or_create_by(name: "Octavio", santoral_day: "03-28")
    General::Santoral.find_or_create_by(name: "Gladys", santoral_day: "03-29")
    General::Santoral.find_or_create_by(name: "Artemio", santoral_day: "03-30")
    General::Santoral.find_or_create_by(name: "Benjamín, Balbina", santoral_day: "03-31")
    General::Santoral.find_or_create_by(name: "Hugo", santoral_day: "04-01")
    General::Santoral.find_or_create_by(name: "Sandra, Francisco de Paula", santoral_day: "04-02")
    General::Santoral.find_or_create_by(name: "Ricardo", santoral_day: "04-03")
    General::Santoral.find_or_create_by(name: "Isidoro", santoral_day: "04-04")
    General::Santoral.find_or_create_by(name: "Vicente Ferrer", santoral_day: "04-05")
    General::Santoral.find_or_create_by(name: "Edith", santoral_day: "04-06")
    General::Santoral.find_or_create_by(name: "Juan Bautista de La Salle", santoral_day: "04-07")
    General::Santoral.find_or_create_by(name: "Constanza", santoral_day: "04-08")
    General::Santoral.find_or_create_by(name: "Demetrio", santoral_day: "04-09")
    General::Santoral.find_or_create_by(name: "Ezequiel", santoral_day: "04-10")
    General::Santoral.find_or_create_by(name: "Estanislao", santoral_day: "04-11")
    General::Santoral.find_or_create_by(name: "Arnoldo, Julio", santoral_day: "04-12")
    General::Santoral.find_or_create_by(name: "Martín, Aída", santoral_day: "04-13")
    General::Santoral.find_or_create_by(name: "Máximo", santoral_day: "04-14")
    General::Santoral.find_or_create_by(name: "Crescente", santoral_day: "04-15")
    General::Santoral.find_or_create_by(name: "Flavio", santoral_day: "04-16")
    General::Santoral.find_or_create_by(name: "Leopoldo, Aniceto", santoral_day: "04-17")
    General::Santoral.find_or_create_by(name: "Wladimir", santoral_day: "04-18")
    General::Santoral.find_or_create_by(name: "Ema", santoral_day: "04-19")
    General::Santoral.find_or_create_by(name: "Edgardo", santoral_day: "04-20")
    General::Santoral.find_or_create_by(name: "Anselmo", santoral_day: "04-21")
    General::Santoral.find_or_create_by(name: "Karina", santoral_day: "04-22")
    General::Santoral.find_or_create_by(name: "Jorge", santoral_day: "04-23")
    General::Santoral.find_or_create_by(name: "Fidel", santoral_day: "04-24")
    General::Santoral.find_or_create_by(name: "Marcos", santoral_day: "04-25")
    General::Santoral.find_or_create_by(name: "Cleto, Marcelino", santoral_day: "04-26")
    General::Santoral.find_or_create_by(name: "Zita, Toribio de Mogrovejo", santoral_day: "04-27")
    General::Santoral.find_or_create_by(name: "Valeria", santoral_day: "04-28")
    General::Santoral.find_or_create_by(name: "Catalina de Siena", santoral_day: "04-29")
    General::Santoral.find_or_create_by(name: "Amador, Pío V", santoral_day: "04-30")
    General::Santoral.find_or_create_by(name: "José Obrero", santoral_day: "05-01")
    General::Santoral.find_or_create_by(name: "Atanasio, Boris", santoral_day: "05-02")
    General::Santoral.find_or_create_by(name: "Santa Cruz", santoral_day: "05-03")
    General::Santoral.find_or_create_by(name: "Felipe y Santiago", santoral_day: "05-04")
    General::Santoral.find_or_create_by(name: "Judit", santoral_day: "05-05")
    General::Santoral.find_or_create_by(name: "Eleodoro", santoral_day: "05-06")
    General::Santoral.find_or_create_by(name: "Domitila", santoral_day: "05-07")
    General::Santoral.find_or_create_by(name: "Segundo", santoral_day: "05-08")
    General::Santoral.find_or_create_by(name: "Isaías", santoral_day: "05-09")
    General::Santoral.find_or_create_by(name: "Antonino-a, Solange", santoral_day: "05-10")
    General::Santoral.find_or_create_by(name: "Estela", santoral_day: "05-11")
    General::Santoral.find_or_create_by(name: "Pancracio, Nereo, Aquiles", santoral_day: "05-12")
    General::Santoral.find_or_create_by(name: "N.S. Fátima", santoral_day: "05-13")
    General::Santoral.find_or_create_by(name: "Matías", santoral_day: "05-14")
    General::Santoral.find_or_create_by(name: "Isidro, Denise", santoral_day: "05-15")
    General::Santoral.find_or_create_by(name: "Honorato", santoral_day: "05-16")
    General::Santoral.find_or_create_by(name: "Pascual Bailón", santoral_day: "05-17")
    General::Santoral.find_or_create_by(name: "Erica, Corina", santoral_day: "05-18")
    General::Santoral.find_or_create_by(name: "Yvo-ne", santoral_day: "05-19")
    General::Santoral.find_or_create_by(name: "Bernardino de Siena", santoral_day: "05-20")
    General::Santoral.find_or_create_by(name: "Constantino", santoral_day: "05-21")
    General::Santoral.find_or_create_by(name: "Rita", santoral_day: "05-22")
    General::Santoral.find_or_create_by(name: "Desiderio", santoral_day: "05-23")
    General::Santoral.find_or_create_by(name: "María Auxiliadora, Susana", santoral_day: "05-24")
    General::Santoral.find_or_create_by(name: "Beda, Gregorio, Ma.Magdalena de Pazzi", santoral_day: "05-25")
    General::Santoral.find_or_create_by(name: "Mariana", santoral_day: "05-26")
    General::Santoral.find_or_create_by(name: "Emilio, Agustín de Cantorbery", santoral_day: "05-27")
    General::Santoral.find_or_create_by(name: "Germán", santoral_day: "05-28")
    General::Santoral.find_or_create_by(name: "Maximiano, Hilda", santoral_day: "05-29")
    General::Santoral.find_or_create_by(name: "Fernando/Hernán, Juana de Arco, Lorena", santoral_day: "05-30")
    General::Santoral.find_or_create_by(name: "Visitación", santoral_day: "05-31")
    General::Santoral.find_or_create_by(name: "Justino, Juvenal", santoral_day: "06-01")
    General::Santoral.find_or_create_by(name: "Marcelino, Erasmo", santoral_day: "06-02")
    General::Santoral.find_or_create_by(name: "Maximiliano, Carlos Lwanga", santoral_day: "06-03")
    General::Santoral.find_or_create_by(name: "Frida", santoral_day: "06-04")
    General::Santoral.find_or_create_by(name: "Bonifacio, Salvador", santoral_day: "06-05")
    General::Santoral.find_or_create_by(name: "Norberto", santoral_day: "06-06")
    General::Santoral.find_or_create_by(name: "Claudio", santoral_day: "06-07")
    General::Santoral.find_or_create_by(name: "Armando", santoral_day: "06-08")
    General::Santoral.find_or_create_by(name: "Efrén", santoral_day: "06-09")
    General::Santoral.find_or_create_by(name: "Paulina", santoral_day: "06-10")
    General::Santoral.find_or_create_by(name: "Bernabé, Trinidad", santoral_day: "06-11")
    General::Santoral.find_or_create_by(name: "Onofre", santoral_day: "06-12")
    General::Santoral.find_or_create_by(name: "Antonio", santoral_day: "06-13")
    General::Santoral.find_or_create_by(name: "Eliseo", santoral_day: "06-14")
    General::Santoral.find_or_create_by(name: "Leonidas, Manuela, Micaela", santoral_day: "06-15")
    General::Santoral.find_or_create_by(name: "Aurelio", santoral_day: "06-16")
    General::Santoral.find_or_create_by(name: "Ismael", santoral_day: "06-17")
    General::Santoral.find_or_create_by(name: "Salomón", santoral_day: "06-18")
    General::Santoral.find_or_create_by(name: "Romualdo", santoral_day: "06-19")
    General::Santoral.find_or_create_by(name: "Florentino", santoral_day: "06-20")
    General::Santoral.find_or_create_by(name: "Raul, Rodolfo, Luís Gonzaga", santoral_day: "06-21")
    General::Santoral.find_or_create_by(name: "Paulino de Nola, Tomáss Moro, Juan Fisher", santoral_day: "06-22")
    General::Santoral.find_or_create_by(name: "Marcial", santoral_day: "06-23")
    General::Santoral.find_or_create_by(name: "Juan Bautista", santoral_day: "06-24")
    General::Santoral.find_or_create_by(name: "Guillermo", santoral_day: "06-25")
    General::Santoral.find_or_create_by(name: "Pelayo", santoral_day: "06-26")
    General::Santoral.find_or_create_by(name: "Cirilo", santoral_day: "06-27")
    General::Santoral.find_or_create_by(name: "Ireneo", santoral_day: "06-28")
    General::Santoral.find_or_create_by(name: "Pedro y Pablo", santoral_day: "06-29")
    General::Santoral.find_or_create_by(name: "Adolfo", santoral_day: "06-30")
    General::Santoral.find_or_create_by(name: "Ester", santoral_day: "07-01")
    General::Santoral.find_or_create_by(name: "Gloria", santoral_day: "07-02")
    General::Santoral.find_or_create_by(name: "Tomás", santoral_day: "07-03")
    General::Santoral.find_or_create_by(name: "Isabel, Eliana, Liliana", santoral_day: "07-04")
    General::Santoral.find_or_create_by(name: "Antonio-María, Berta", santoral_day: "07-05")
    General::Santoral.find_or_create_by(name: "María Goretti", santoral_day: "07-06")
    General::Santoral.find_or_create_by(name: "Fermín", santoral_day: "07-07")
    General::Santoral.find_or_create_by(name: "Eugenio", santoral_day: "07-08")
    General::Santoral.find_or_create_by(name: "Verónica", santoral_day: "07-09")
    General::Santoral.find_or_create_by(name: "Elías", santoral_day: "07-10")
    General::Santoral.find_or_create_by(name: "Benito", santoral_day: "07-11")
    General::Santoral.find_or_create_by(name: "Filomena", santoral_day: "07-12")
    General::Santoral.find_or_create_by(name: "Teresa de los Andes, Enrique, Joel", santoral_day: "07-13")
    General::Santoral.find_or_create_by(name: "Camilo de Lelis", santoral_day: "07-14")
    General::Santoral.find_or_create_by(name: "Buenaventura, Julio/a", santoral_day: "07-15")
    General::Santoral.find_or_create_by(name: "Carmen", santoral_day: "07-16")
    General::Santoral.find_or_create_by(name: "Carolina", santoral_day: "07-17")
    General::Santoral.find_or_create_by(name: "Federico", santoral_day: "07-18")
    General::Santoral.find_or_create_by(name: "Arsenio", santoral_day: "07-19")
    General::Santoral.find_or_create_by(name: "Marina", santoral_day: "07-20")
    General::Santoral.find_or_create_by(name: "Daniel", santoral_day: "07-21")
    General::Santoral.find_or_create_by(name: "María Magdalena", santoral_day: "07-22")
    General::Santoral.find_or_create_by(name: "Brigida", santoral_day: "07-23")
    General::Santoral.find_or_create_by(name: "Cristina", santoral_day: "07-24")
    General::Santoral.find_or_create_by(name: "Santiago", santoral_day: "07-25")
    General::Santoral.find_or_create_by(name: "Joaquín, Ana", santoral_day: "07-26")
    General::Santoral.find_or_create_by(name: "Natalia", santoral_day: "07-27")
    General::Santoral.find_or_create_by(name: "Celso", santoral_day: "07-28")
    General::Santoral.find_or_create_by(name: "Marta", santoral_day: "07-29")
    General::Santoral.find_or_create_by(name: "Abdón y Senén", santoral_day: "07-30")
    General::Santoral.find_or_create_by(name: "Ignacio de Loyola", santoral_day: "07-31")
    General::Santoral.find_or_create_by(name: "Alfonso María de Ligorio", santoral_day: "08-01")
    General::Santoral.find_or_create_by(name: "Eusebio", santoral_day: "08-02")
    General::Santoral.find_or_create_by(name: "Lydia", santoral_day: "08-03")
    General::Santoral.find_or_create_by(name: "Juan María Vianney", santoral_day: "08-04")
    General::Santoral.find_or_create_by(name: "Osvaldo, Nieves", santoral_day: "08-05")
    General::Santoral.find_or_create_by(name: "(Transfiguración)", santoral_day: "08-06")
    General::Santoral.find_or_create_by(name: "Sixto, Cayetano", santoral_day: "08-07")
    General::Santoral.find_or_create_by(name: "Domingo de Guzmán", santoral_day: "08-08")
    General::Santoral.find_or_create_by(name: "Justo", santoral_day: "08-09")
    General::Santoral.find_or_create_by(name: "Lorenzo", santoral_day: "08-10")
    General::Santoral.find_or_create_by(name: "Clara de Asís", santoral_day: "08-11")
    General::Santoral.find_or_create_by(name: "Laura", santoral_day: "08-12")
    General::Santoral.find_or_create_by(name: "Víctor", santoral_day: "08-13")
    General::Santoral.find_or_create_by(name: "Maximiliano Kolbe, Alfredo", santoral_day: "08-14")
    General::Santoral.find_or_create_by(name: "Asunción", santoral_day: "08-15")
    General::Santoral.find_or_create_by(name: "Esteban de Hungría, Roque", santoral_day: "08-16")
    General::Santoral.find_or_create_by(name: "Jacinto", santoral_day: "08-17")
    General::Santoral.find_or_create_by(name: "Alberto Hurtado, Elena, Nelly, Leticia", santoral_day: "08-18")
    General::Santoral.find_or_create_by(name: "Mariano", santoral_day: "08-19")
    General::Santoral.find_or_create_by(name: "Bernardo", santoral_day: "08-20")
    General::Santoral.find_or_create_by(name: "Pío X, Graciela", santoral_day: "08-21")
    General::Santoral.find_or_create_by(name: "María Reina", santoral_day: "08-22")
    General::Santoral.find_or_create_by(name: "Donato", santoral_day: "08-23")
    General::Santoral.find_or_create_by(name: "Bartolomé", santoral_day: "08-24")
    General::Santoral.find_or_create_by(name: "Luís (rey), José Calasanz", santoral_day: "08-25")
    General::Santoral.find_or_create_by(name: "Teresa de Jesús Jornet e Ibars, César", santoral_day: "08-26")
    General::Santoral.find_or_create_by(name: "Mónica", santoral_day: "08-27")
    General::Santoral.find_or_create_by(name: "Agustín", santoral_day: "08-28")
    General::Santoral.find_or_create_by(name: "Juan Bautista, Sabina", santoral_day: "08-29")
    General::Santoral.find_or_create_by(name: "Rosa de Lima", santoral_day: "08-30")
    General::Santoral.find_or_create_by(name: "Ramón", santoral_day: "08-31")
    General::Santoral.find_or_create_by(name: "Arturo", santoral_day: "09-01")
    General::Santoral.find_or_create_by(name: "Moisés", santoral_day: "09-02")
    General::Santoral.find_or_create_by(name: "Gregorio Magno", santoral_day: "09-03")
    General::Santoral.find_or_create_by(name: "Irma", santoral_day: "09-04")
    General::Santoral.find_or_create_by(name: "Victorino", santoral_day: "09-05")
    General::Santoral.find_or_create_by(name: "Eva, Evelyne", santoral_day: "09-06")
    General::Santoral.find_or_create_by(name: "Regina", santoral_day: "09-07")
    General::Santoral.find_or_create_by(name: "Natividad de la Virgen", santoral_day: "09-08")
    General::Santoral.find_or_create_by(name: "Sergio y Omar", santoral_day: "09-09")
    General::Santoral.find_or_create_by(name: "Nicolás de Tolentino, Adalberto", santoral_day: "09-10")
    General::Santoral.find_or_create_by(name: "Orlando, Rolando", santoral_day: "09-11")
    General::Santoral.find_or_create_by(name: "María", santoral_day: "09-12")
    General::Santoral.find_or_create_by(name: "Juan Crisóstomo", santoral_day: "09-13")
    General::Santoral.find_or_create_by(name: "Imelda", santoral_day: "09-14")
    General::Santoral.find_or_create_by(name: "N.Sra.de Dolores", santoral_day: "09-15")
    General::Santoral.find_or_create_by(name: "Cornelio, Cipriano", santoral_day: "09-16")
    General::Santoral.find_or_create_by(name: "Roberto Belarmino", santoral_day: "09-17")
    General::Santoral.find_or_create_by(name: "José de Cupertino", santoral_day: "09-18")
    General::Santoral.find_or_create_by(name: "Jenaro", santoral_day: "09-19")
    General::Santoral.find_or_create_by(name: "Amelia, Andrés Kim y Pablo Tung", santoral_day: "09-20")
    General::Santoral.find_or_create_by(name: "Mateo", santoral_day: "09-21")
    General::Santoral.find_or_create_by(name: "Mauricio", santoral_day: "09-22")
    General::Santoral.find_or_create_by(name: "Lino y Tecla", santoral_day: "09-23")
    General::Santoral.find_or_create_by(name: "N.Sra.del Carmen", santoral_day: "09-24")
    General::Santoral.find_or_create_by(name: "Aurelio", santoral_day: "09-25")
    General::Santoral.find_or_create_by(name: "Cosme y Damián", santoral_day: "09-26")
    General::Santoral.find_or_create_by(name: "Vicente de Paul", santoral_day: "09-27")
    General::Santoral.find_or_create_by(name: "Wenceslao", santoral_day: "09-28")
    General::Santoral.find_or_create_by(name: "Miguel, Gabriel y Rafael", santoral_day: "09-29")
    General::Santoral.find_or_create_by(name: "Jerónimo", santoral_day: "09-30")
    General::Santoral.find_or_create_by(name: "Teresita del Niño Jesús", santoral_day: "10-01")
    General::Santoral.find_or_create_by(name: "Angeles Custodios", santoral_day: "10-02")
    General::Santoral.find_or_create_by(name: "Gerardo", santoral_day: "10-03")
    General::Santoral.find_or_create_by(name: "Francisco de Asís", santoral_day: "10-04")
    General::Santoral.find_or_create_by(name: "Flor", santoral_day: "10-05")
    General::Santoral.find_or_create_by(name: "Bruno", santoral_day: "10-06")
    General::Santoral.find_or_create_by(name: "N.Sra.del Rosario", santoral_day: "10-07")
    General::Santoral.find_or_create_by(name: "N.Sra.de Begoña", santoral_day: "10-08")
    General::Santoral.find_or_create_by(name: "Dionisio; Juan Leonardi", santoral_day: "10-09")
    General::Santoral.find_or_create_by(name: "Francisco de Borja", santoral_day: "10-10")
    General::Santoral.find_or_create_by(name: "Soledad", santoral_day: "10-11")
    General::Santoral.find_or_create_by(name: "N.Sra.del Pilar", santoral_day: "10-12")
    General::Santoral.find_or_create_by(name: "Eduardo", santoral_day: "10-13")
    General::Santoral.find_or_create_by(name: "Calixto", santoral_day: "10-14")
    General::Santoral.find_or_create_by(name: "Teresa de Avila", santoral_day: "10-15")
    General::Santoral.find_or_create_by(name: "Eduvigis, Margarita Ma.Alacoque", santoral_day: "10-16")
    General::Santoral.find_or_create_by(name: "Ignacio de Antioquía", santoral_day: "10-17")
    General::Santoral.find_or_create_by(name: "Lucas", santoral_day: "10-18")
    General::Santoral.find_or_create_by(name: "Pablo de la Cruz, Renato", santoral_day: "10-19")
    General::Santoral.find_or_create_by(name: "Irene", santoral_day: "10-20")
    General::Santoral.find_or_create_by(name: "Úrsula", santoral_day: "10-21")
    General::Santoral.find_or_create_by(name: "Sara", santoral_day: "10-22")
    General::Santoral.find_or_create_by(name: "Juan Capistrano, Remigio", santoral_day: "10-23")
    General::Santoral.find_or_create_by(name: "Antonio Ma.Claret", santoral_day: "10-24")
    General::Santoral.find_or_create_by(name: "Olga", santoral_day: "10-25")
    General::Santoral.find_or_create_by(name: "Darío", santoral_day: "10-26")
    General::Santoral.find_or_create_by(name: "Gustavo", santoral_day: "10-27")
    General::Santoral.find_or_create_by(name: "Simón, Judas", santoral_day: "10-28")
    General::Santoral.find_or_create_by(name: "Narciso", santoral_day: "10-29")
    General::Santoral.find_or_create_by(name: "Alonso", santoral_day: "10-30")
    General::Santoral.find_or_create_by(name: "Quintin", santoral_day: "10-31")
    General::Santoral.find_or_create_by(name: "Todos los Santos", santoral_day: "11-01")
    General::Santoral.find_or_create_by(name: "Todos los Fieles difuntos", santoral_day: "11-02")
    General::Santoral.find_or_create_by(name: "Martín de Porres", santoral_day: "11-03")
    General::Santoral.find_or_create_by(name: "Carlos Borromeo", santoral_day: "11-04")
    General::Santoral.find_or_create_by(name: "Silvia", santoral_day: "11-05")
    General::Santoral.find_or_create_by(name: "Leonardo", santoral_day: "11-06")
    General::Santoral.find_or_create_by(name: "Ernesto-ina", santoral_day: "11-07")
    General::Santoral.find_or_create_by(name: "Ninfa, Godofredo", santoral_day: "11-08")
    General::Santoral.find_or_create_by(name: "Teodoro", santoral_day: "11-09")
    General::Santoral.find_or_create_by(name: "León Magno", santoral_day: "11-10")
    General::Santoral.find_or_create_by(name: "Martín de Tours", santoral_day: "11-11")
    General::Santoral.find_or_create_by(name: "Cristián", santoral_day: "11-12")
    General::Santoral.find_or_create_by(name: "Diego", santoral_day: "11-13")
    General::Santoral.find_or_create_by(name: "Humberto", santoral_day: "11-14")
    General::Santoral.find_or_create_by(name: "Alberto Magno", santoral_day: "11-15")
    General::Santoral.find_or_create_by(name: "Margarita, Gertrudis", santoral_day: "11-16")
    General::Santoral.find_or_create_by(name: "Isabel de Hungría", santoral_day: "11-17")
    General::Santoral.find_or_create_by(name: "Elsa", santoral_day: "11-18")
    General::Santoral.find_or_create_by(name: "Andrés Avelino", santoral_day: "11-19")
    General::Santoral.find_or_create_by(name: "Edmundo", santoral_day: "11-20")
    General::Santoral.find_or_create_by(name: "Presentación de la Virgen", santoral_day: "11-21")
    General::Santoral.find_or_create_by(name: "Cecilia", santoral_day: "11-22")
    General::Santoral.find_or_create_by(name: "Clemento, Columbano", santoral_day: "11-23")
    General::Santoral.find_or_create_by(name: "Flora, Andrés Dung-Lac", santoral_day: "11-24")
    General::Santoral.find_or_create_by(name: "Catalina Labouré", santoral_day: "11-25")
    General::Santoral.find_or_create_by(name: "Delfina", santoral_day: "11-26")
    General::Santoral.find_or_create_by(name: "Virgilio", santoral_day: "11-27")
    General::Santoral.find_or_create_by(name: "Blanca", santoral_day: "11-28")
    General::Santoral.find_or_create_by(name: "Saturnino", santoral_day: "11-29")
    General::Santoral.find_or_create_by(name: "Andrés", santoral_day: "11-30")
    General::Santoral.find_or_create_by(name: "Florencia", santoral_day: "12-01")
    General::Santoral.find_or_create_by(name: "Viviana", santoral_day: "12-02")
    General::Santoral.find_or_create_by(name: "Francisco Javier", santoral_day: "12-03")
    General::Santoral.find_or_create_by(name: "Juan Damaceno, Bárbara", santoral_day: "12-04")
    General::Santoral.find_or_create_by(name: "Ada", santoral_day: "12-05")
    General::Santoral.find_or_create_by(name: "Nicolás", santoral_day: "12-06")
    General::Santoral.find_or_create_by(name: "Ambrosio", santoral_day: "12-07")
    General::Santoral.find_or_create_by(name: "Inmaculada Concepción", santoral_day: "12-08")
    General::Santoral.find_or_create_by(name: "Jéssica", santoral_day: "12-09")
    General::Santoral.find_or_create_by(name: "N. Sra. de Loreto, Eulalia", santoral_day: "12-10")
    General::Santoral.find_or_create_by(name: "Dámaso", santoral_day: "12-11")
    General::Santoral.find_or_create_by(name: "N. Sra. de Guadalupe", santoral_day: "12-12")
    General::Santoral.find_or_create_by(name: "Lucía", santoral_day: "12-13")
    General::Santoral.find_or_create_by(name: "Juan de la Cruz", santoral_day: "12-14")
    General::Santoral.find_or_create_by(name: "Reinaldo", santoral_day: "12-15")
    General::Santoral.find_or_create_by(name: "Alicia", santoral_day: "12-16")
    General::Santoral.find_or_create_by(name: "Lázaro", santoral_day: "12-17")
    General::Santoral.find_or_create_by(name: "Sonia", santoral_day: "12-18")
    General::Santoral.find_or_create_by(name: "Urbano", santoral_day: "12-19")
    General::Santoral.find_or_create_by(name: "Abrahám, Isaac, Jacob", santoral_day: "12-20")
    General::Santoral.find_or_create_by(name: "Pedro Canisio", santoral_day: "12-21")
    General::Santoral.find_or_create_by(name: "Fabiola", santoral_day: "12-22")
    General::Santoral.find_or_create_by(name: "Victoria", santoral_day: "12-23")
    General::Santoral.find_or_create_by(name: "Adela", santoral_day: "12-24")
    General::Santoral.find_or_create_by(name: "Natividad del Señor (Noel, Noelia)", santoral_day: "12-25")
    General::Santoral.find_or_create_by(name: "Esteban", santoral_day: "12-26")
    General::Santoral.find_or_create_by(name: "Juan", santoral_day: "12-27")
    General::Santoral.find_or_create_by(name: "Stos. Inocentes", santoral_day: "12-28")
    General::Santoral.find_or_create_by(name: "Tomás Becket, David", santoral_day: "12-29")
    General::Santoral.find_or_create_by(name: "Rogelio", santoral_day: "12-30")
    General::Santoral.find_or_create_by(name: "Silvestre", santoral_day: "12-31")

    puts("******* Creando Menús Padres *******")
    General::Menu.find_or_create_by(title: "EN LINEA")
    General::Menu.find_or_create_by(title: "INFORMADOS")
    General::Menu.find_or_create_by(title: "MIS BENEFICIOS")
    puts("******* Creando Menús Hijos *******")
    menu_1 = General::Menu.find_by_title("EN LINEA")
    menu_2 = General::Menu.find_by_title("INFORMADOS")
    menu_3 = General::Menu.find_by_title("MIS BENEFICIOS")
    menu = General::Menu.find_or_create_by(
      title: "Vacaciones",
      description: "Vacaciones Security",
      css_class: "#000000",
      link: "vacaciones",
      priority: nil,
      parent_id: menu_1.id,
      integration_code: "vacs",
    )
    vacation = General::Menu.find_by_title("Vacaciones")
    menu = General::Menu.find_or_create_by(
      title: "Mis Vacaciones",
      description: "Mis Vacaciones",
      css_class: "#db9398",
      link: "https://misecurity.exa.cl/vac_records_register/index",
      priority: nil,
      parent_id: vacation.id,
    )
    menu = General::Menu.find_or_create_by(
      title: "Aprobación",
      description: "Aprobación",
      css_class: "#db9398",
      post_id: extra_post.id,
      priority: nil,
      parent_id: vacation.id,
    )
    menu = General::Menu.find_or_create_by(
      title: "Vacaciones progresivas",
      description: "Vacaciones progresivas",
      css_class: "#db3562",
      post_id: extra_post.id,
      priority: nil,
      parent_id: vacation.id,
    )
    #->Permisos
    menu = General::Menu.find_or_create_by(
      title: "Permisos",
      description: "Permisos",
      css_class: "#243in0",
      link: "",
      priority: nil,
      parent_id: menu_1.id,
    )
    permission = General::Menu.find_by_title("Permisos")
    # 24 Horas para algo importante
    menu = General::Menu.find_or_create_by(
      title: "24 Horas para algo importante",
      description: "24 Horas para algo importante",
      css_class: "#3nnd99",
      post_id: extra_post.id,
      priority: nil,
      parent_id: permission.id,
    )
    # Post Natal Paterno
    menu = General::Menu.find_or_create_by(
      title: "Post Natal Paterno",
      description: "Post Natal Paterno",
      css_class: "#346kg9",
      post_id: extra_post.id,
      priority: nil,
      parent_id: permission.id,
    )
    # Matrimonio
    menu = General::Menu.find_or_create_by(
      title: "Matrimonio",
      description: "Matrimonio",
      css_class: "#93899h",
      post_id: extra_post.id,
      priority: nil,
      parent_id: permission.id,
    )
    # Unión Civil
    menu = General::Menu.find_or_create_by(
      title: "Unión Civil",
      description: "Unión Civil",
      css_class: "#64334f",
      post_id: extra_post.id,
      priority: nil,
      parent_id: permission.id,
    )
    # Fallecimiento
    menu = General::Menu.find_or_create_by(
      title: "Fallecimiento",
      description: "Fallecimiento",
      css_class: "#04jdj9",
      post_id: extra_post.id,
      priority: nil,
      parent_id: permission.id,
    )
    # Examen de Grado
    menu = General::Menu.find_or_create_by(
      title: "Examen de Grado",
      description: "Examen de Grado",
      css_class: "#04jdj9",
      post_id: extra_post.id,
      priority: nil,
      parent_id: permission.id,
    )
    # Exámenes Preventivos
    menu = General::Menu.find_or_create_by(
      title: "Exámenes Preventivos",
      description: "Exámenes Preventivos",
      css_class: "#983839",
      post_id: extra_post.id,
      priority: nil,
      parent_id: permission.id,
    )
    # Día Libre para cambio de casa
    menu = General::Menu.find_or_create_by(
      title: "Día Libre para cambio de casa",
      description: "Día Libre para cambio de casa",
      css_class: "#7889s0",
      post_id: extra_post.id,
      priority: nil,
      parent_id: permission.id,
    )
    #->Tarjeta de trabajo bien hecho
    menu = General::Menu.find_or_create_by(
      title: "Tarjeta de trabajo bien hecho",
      description: "Tarjeta de trabajo bien hecho",
      css_class: "#c5590k",
      link: "",
      priority: nil,
      parent_id: menu_1.id,
    )
    work_card = General::Menu.find_by_title("Tarjeta de trabajo bien hecho")
    #Ingresar tarjeta
    menu = General::Menu.find_or_create_by(
      title: "Ingresar tarjeta",
      description: "Ingresar tarjeta",
      css_class: "#9883hb",
      post_id: extra_post.id,
      priority: nil,
      parent_id: work_card.id,
    )
    #Mis tarjetas
    menu = General::Menu.find_or_create_by(
      title: "Mis tarjetas",
      description: "Mis tarjetas",
      css_class: "#989390",
      post_id: extra_post.id,
      priority: nil,
      parent_id: work_card.id,
    )
    #->Selección
    menu = General::Menu.find_or_create_by(
      title: "Selección",
      description: "Selección",
      css_class: "#m28390",
      link: "",
      priority: nil,
      parent_id: menu_1.id,
      integration_code: "sel",
    )
    selection = General::Menu.find_by_title("Selección")
    #Ingreso solicitudes
    menu = General::Menu.find_or_create_by(
      title: "Ingreso solicitudes",
      description: "Ingreso solicitudes",
      css_class: "#n89279",
      link: "https://misecurity.exa.cl/sel_requirements/new",
      priority: nil,
      parent_id: selection.id,
    )
    #Seguimiento
    menu = General::Menu.find_or_create_by(
      title: "Seguimiento",
      description: "Seguimiento",
      css_class: "#g77900",
      link: "https://misecurity.exa.cl/sel_process_trackers",
      priority: nil,
      parent_id: selection.id,
    )
    #Mis solicitudes
    menu = General::Menu.find_or_create_by(
      title: "Mis solicitudes",
      description: "Mis solicitudes",
      css_class: "#yu8999",
      link: "https://misecurity.exa.cl/sel_requirements/mine",
      priority: nil,
      parent_id: selection.id,
    )
    #Evaluación de solicitudes
    menu = General::Menu.find_or_create_by(
      title: "Evaluación de solicitudes",
      description: "Evaluación de solicitudes",
      css_class: "#b77890",
      link: "https://misecurity.exa.cl/sel_req_processes/eval/to_eval",
      priority: nil,
      parent_id: selection.id,
    )
    #->Desempeño y Desarrollo
    menu = General::Menu.find_or_create_by(
      title: "Desempeño y Desarrollo",
      description: "Desempeño y Desarrollo",
      css_class: "#968390",
      link: "",
      priority: nil,
      parent_id: menu_1.id,
      integration_code: "pe",
    )
    development = General::Menu.find_by_title("Desempeño y Desarrollo")
    #Plan de desarrollo profesional
    menu = General::Menu.find_or_create_by(
      title: "Plan de desarrollo profesional",
      description: "Plan de desarrollo profesional",
      css_class: "#v77890",
      link: "https://misecurity.exa.cl/tracking_processes/3/index",
      priority: nil,
      parent_id: development.id,
    )
    #Feedback
    menu = General::Menu.find_or_create_by(
      title: "Feedback",
      description: "Feedback",
      css_class: "#v77890",
      link: "https://misecurity.exa.cl/pe/uniq",
      priority: nil,
      parent_id: development.id,
    )
    #Talento
    menu = General::Menu.find_or_create_by(
      title: "Talento",
      description: "Talento",
      css_class: "#d77780",
      post_id: extra_post.id,
      priority: nil,
      parent_id: development.id,
    )
    #(Tal cual está ahora en exa)
    menu = # General::Menu.find_or_create_by(
      #title: "Talento",
      #description: "Talento",
      #css_class: "#d77780",
      #code: 82799,
      #link: "talento",
      #priority: nil,
      #parent_id: development.id
      # )
      #Gestionar
      General::Menu.find_or_create_by(
        title: "Gestionar",
        description: "Gestionar",
        css_class: "#641160",
        link: "capacitacion-funcional",
        priority: nil,
        parent_id: menu_1.id,
        integration_code: "manage",
      )
    #Beneficios
    General::Menu.find_or_create_by(
      title: "Beneficios",
      description: "Beneficios",
      css_class: "#641160",
      link: "capacitacion-funcional",
      priority: nil,
      parent_id: menu_3.id,
      integration_code: "licenses",
    )
    #Bono Rol General
    General::Menu.find_or_create_by(
      title: "Bono Rol General",
      description: "Bono Rol General",
      css_class: "#641160",
      link: "capacitacion-funcional",
      priority: nil,
      parent_id: menu_3.id,
      integration_code: "brg",
    )
    #Capacitémonos
    General::Menu.find_or_create_by(
      title: "Capacitémonos",
      description: "Capacitémonos",
      css_class: "#641160",
      link: "capacitacion-funcional",
      priority: nil,
      parent_id: menu_1.id,
      integration_code: "tr",
    )
    #Biblioteca
    General::Menu.find_or_create_by(
      title: "Biblioteca",
      description: "Biblioteca",
      css_class: "#641160",
      link: "capacitacion-funcional",
      priority: nil,
      parent_id: menu_1.id,
      integration_code: "lib",
    )
    #Mesa Ayuda
    General::Menu.find_or_create_by(
      title: "Mesa Ayuda",
      description: "Mesa de ayuda",
      css_class: "#641160",
      link: "capacitacion-funcional",
      priority: nil,
      parent_id: menu_1.id,
      integration_code: "hd",
    )
    #Capacitemonos
    menu = General::Menu.find_or_create_by(
      title: "Capacitemonos",
      description: "Capacitemonos",
      css_class: "#768393",
      link: "",
      priority: nil,
      parent_id: menu_1.id,
    )
    capacitation = General::Menu.find_by_title("Capacitemonos")
    #Capacitación Corporativa
    menu = General::Menu.find_or_create_by(
      title: "Capacitación Corporativa",
      description: "Capacitación Corporativa",
      css_class: "#647720",
      post_id: extra_post.id,
      priority: nil,
      parent_id: capacitation.id,
    )
    #Capacitación Funcional
    menu = General::Menu.find_or_create_by(
      title: "Capacitación Funcional",
      description: "Capacitación Funcional",
      css_class: "#641160",
      post_id: extra_post.id,
      priority: nil,
      parent_id: capacitation.id,
    )
    #Programa de capacitación
    menu = General::Menu.find_or_create_by(
      title: "Programa de capacitación",
      description: "Programa de capacitación",
      css_class: "#649370",
      post_id: extra_post.id,
      priority: nil,
      parent_id: capacitation.id,
    )
    #Material de Capacitación
    menu = General::Menu.find_or_create_by(
      title: "Material de Capacitación",
      description: "Material de Capacitación",
      css_class: "#379908",
      link: "https://misecurity.exa.cl/biblioteca",
      priority: nil,
      parent_id: capacitation.id,
    )
    #Historial de Capacitación
    menu = General::Menu.find_or_create_by(
      title: "Historial de Capacitación",
      description: "Historial de Capacitación",
      css_class: "#379100",
      link: "https://misecurity.exa.cl/user_profile",
      priority: nil,
      parent_id: capacitation.id,
    )
    #->Remuneraciones
    menu = General::Menu.find_or_create_by(
      title: "Remuneraciones",
      description: "Remuneraciones",
      css_class: "#366678",
      link: "",
      priority: nil,
      parent_id: menu_1.id,
    )
    remuneration = General::Menu.find_by_title("Remuneraciones")
    #Liquidaciones
    menu = General::Menu.find_or_create_by(
      title: "Liquidaciones",
      description: "Liquidaciones",
      css_class: "#299900",
      link: "https://expert.adpsoluciones.com/Expert/inicio/ini/Login.aspx?AspxAutoDetectCookieSupport=1",
      priority: nil,
      parent_id: remuneration.id,
    )
    #Anticipos
    menu = General::Menu.find_or_create_by(
      title: "Anticipos",
      description: "Anticipos",
      css_class: "#23929",
      link: "https://expert.adpsoluciones.com/Expert/inicio/ini/Login.aspx?AspxAutoDetectCookieSupport=1",
      priority: nil,
      parent_id: remuneration.id,
    )
    #APV
    menu = General::Menu.find_or_create_by(
      title: "APV",
      description: "APV",
      css_class: "#23121",
      post_id: extra_post.id,
      priority: nil,
      parent_id: remuneration.id,
    )
    #Certificados
    menu = General::Menu.find_or_create_by(
      title: "Certificados",
      description: "Certificados",
      css_class: "#88999",
      link: "",
      priority: nil,
      parent_id: menu_1.id,
    )
    certification = General::Menu.find_by_title("Certificados")
    #Antigüedad
    menu = General::Menu.find_or_create_by(
      title: "Antigüedad",
      description: "Antigüedad",
      css_class: "#29929",
      post_id: extra_post.id,
      priority: nil,
      parent_id: certification.id,
    )
    #Renta
    menu = General::Menu.find_or_create_by(
      title: "Renta",
      description: "Renta",
      css_class: "#22929",
      post_id: extra_post.id,
      priority: nil,
      parent_id: certification.id,
    )
    ################################################ TERMINO EN LINEA ################################################
    #->Noticias
    menu = General::Menu.find_or_create_by(
      title: "Noticias",
      description: "Noticias new menu",
      css_class: "#b13362",
      link: "",
      priority: nil,
      parent_id: menu_2.id,
    )
    # General::Menu.create(
    #title: "Noticias",
    #description: "Noticias new menu",
    #css_class: "#b13362",
    #code: 1235,
    #link: "",
    #priority: nil,
    #parent_id: nil
    # )
    post = General::Menu.find_by_description("Noticias new menu")
    #Corporativas
    menu = General::Menu.find_or_create_by(
      title: "Corporativas",
      description: "corporativas",
      css_class: "#b13362",
      link: "corporativas",
      priority: nil,
      parent_id: post.id,
    )
    #Miscelaneos
    menu = General::Menu.find_or_create_by(
      title: "Miscelaneos",
      description: "Miscelaneos",
      css_class: "#b10312",
      link: "miscelaneos",
      priority: nil,
      parent_id: post.id,
    )
    #Conociéndonos
    menu = General::Menu.find_or_create_by(
      title: "Conociéndonos",
      description: "Conociéndonos",
      css_class: "#a15293",
      link: "conociendonos",
      priority: nil,
      parent_id: post.id,
    )
    #->Políticas
    menu = General::Menu.find_or_create_by(
      title: "Políticas",
      description: "Políticas",
      css_class: "#bp1332",
      link: "",
      priority: nil,
      parent_id: menu_2.id,
    )
    politic = General::Menu.find_by_title("Políticas")
    #Corporativas
    menu = General::Menu.find_or_create_by(
      title: "Corporativas",
      description: "Corporativas",
      css_class: "#65293",
      link: "https://misecurity.exa.cl/biblioteca/134",
      priority: nil,
      parent_id: politic.id,
    )
    #Políticas Factoring Security
    menu = General::Menu.find_or_create_by(
      title: "Políticas Factoring Security",
      description: "Políticas Factoring Security",
      css_class: "#93293",
      link: "https://misecurity.exa.cl/biblioteca/135",
      priority: nil,
      parent_id: politic.id,
    )
    #Políticas Inversiones Security
    menu = General::Menu.find_or_create_by(
      title: "Políticas Inversiones Security",
      description: "Políticas Inversiones Security",
      css_class: "#92213",
      link: "https://misecurity.exa.cl/biblioteca/136",
      priority: nil,
      parent_id: politic.id,
    )
    #Políticas Corredora Security
    menu = General::Menu.find_or_create_by(
      title: "Políticas Corredora Security",
      description: "Políticas Corredora Security",
      css_class: "#52413",
      link: "https://misecurity.exa.cl/biblioteca/137",
      priority: nil,
      parent_id: politic.id,
    )
    #Políticas Travel Security
    menu = General::Menu.find_or_create_by(
      title: "Políticas Travel Security",
      description: "Políticas Travel Security",
      css_class: "#59213",
      link: "https://misecurity.exa.cl/biblioteca/138",
      priority: nil,
      parent_id: politic.id,
    )
    #Políticas Banco Security
    menu = General::Menu.find_or_create_by(
      title: "Políticas Banco Security",
      description: "Políticas Banco Security",
      css_class: "#52233",
      link: "https://misecurity.exa.cl/biblioteca/139",
      priority: nil,
      parent_id: politic.id,
    )
    #Políticas Vida Security
    menu = General::Menu.find_or_create_by(
      title: "Políticas Vida Security",
      description: "Políticas Vida Security",
      css_class: "#58211",
      link: "https://misecurity.exa.cl/biblioteca/140",
      priority: nil,
      parent_id: politic.id,
    )
    #Políticas Mandatos Security
    menu = General::Menu.find_or_create_by(
      title: "Políticas Mandatos Security",
      description: "Políticas Mandatos Security",
      css_class: "#58019",
      link: "https://misecurity.exa.cl/biblioteca/141",
      priority: nil,
      parent_id: politic.id,
    )
    #Políticas Grupo Security
    menu = General::Menu.find_or_create_by(
      title: "Políticas Grupo Security",
      description: "Políticas Grupo Security",
      css_class: "#52419",
      link: "https://misecurity.exa.cl/biblioteca/142",
      priority: nil,
      parent_id: politic.id,
    )
    #Políticas Hipotecaria
    menu = General::Menu.find_or_create_by(
      title: "Políticas Hipotecaria",
      description: "Políticas Hipotecaria",
      css_class: "#56411",
      link: "https://misecurity.exa.cl/biblioteca/143",
      priority: nil,
      parent_id: politic.id,
    )
    #->Guardianes del Security
    menu = General::Menu.find_or_create_by(
      title: "Guardianes del Security",
      description: "Guardianes del Security",
      css_class: "#p19362",
      link: "",
      priority: nil,
      parent_id: menu_2.id,
    )
    guardian = General::Menu.find_by_title("Guardianes del Security")
    #Información importante
    menu = General::Menu.find_or_create_by(
      title: "Información importante",
      description: "Información importante",
      css_class: "#96312",
      post_id: extra_post.id,
      priority: nil,
      parent_id: guardian.id,
    )
    #Tutoriales
    menu = General::Menu.find_or_create_by(
      title: "Tutoriales",
      description: "Tutoriales",
      css_class: "#93382",
      post_id: extra_post.id,
      priority: nil,
      parent_id: guardian.id,
    )
    #Cliente Integral
    menu = General::Menu.find_or_create_by(
      title: "Cliente Integral",
      description: "Cliente Integral",
      css_class: "#139362",
      link: "",
      priority: nil,
      parent_id: menu_2.id,
    )
    integral = General::Menu.find_by_title("Cliente Integral")
    #Refiere aquí
    menu = General::Menu.find_or_create_by(
      title: "Refiere aquí",
      description: "Refiere aquí",
      css_class: "#92352",
      link: "http://integracion.gr.security.cl/modules/uinfo/referidos.php",
      priority: nil,
      parent_id: integral.id,
    )
    #Acceso al sitio
    menu = General::Menu.find_or_create_by(
      title: "Acceso al sitio ",
      description: "Acceso al sitio ",
      css_class: "#92654",
      link: "http://clienteintegral.security.cl/",
      priority: nil,
      parent_id: integral.id,
    )
    #Busca tu cliente
    menu = General::Menu.find_or_create_by(
      title: "Busca tu cliente ",
      description: "Busca tu cliente ",
      css_class: "#92654",
      link: "http://ventacruzadabo/ConsultaClienteIntegral.aspx",
      priority: nil,
      parent_id: integral.id,
    )
    #->Reconociendo
    menu = General::Menu.find_or_create_by(
      title: "Reconociendo",
      description: "Reconociendo",
      css_class: "#00034",
      link: "",
      priority: nil,
      parent_id: menu_2.id,
    )
    recognize = General::Menu.find_by_title("Reconociendo")
    #Tarjeta de trabajo bien hecho
    menu = General::Menu.find_or_create_by(
      title: "Tarjeta de trabajo bien hecho ",
      description: "Tarjeta de trabajo bien hecho ",
      css_class: "#002838",
      post_id: extra_post.id,
      priority: nil,
      parent_id: recognize.id,
    )
    #Premio Espíritu
    menu = General::Menu.find_or_create_by(
      title: "Premio Espíritu",
      description: "Premio Espíritu",
      css_class: "#006868",
      post_id: extra_post.id,
      priority: nil,
      parent_id: recognize.id,
    )
    #Premio Integración
    menu = General::Menu.find_or_create_by(
      title: "Premio Integración",
      description: "Premio Integración",
      css_class: "#001811",
      post_id: extra_post.id,
      priority: nil,
      parent_id: recognize.id,
    )
    #Premio Calidad de servicio
    menu = General::Menu.find_or_create_by(
      title: "Premio Calidad de servicio",
      description: "Premio Calidad de servicio",
      css_class: "#002289",
      post_id: extra_post.id,
      priority: nil,
      parent_id: recognize.id,
    )
    #Grupo Best
    menu = General::Menu.find_or_create_by(
      title: "Grupo Best",
      description: "Grupo Best",
      css_class: "#007778",
      post_id: extra_post.id,
      priority: nil,
      parent_id: recognize.id,
    )
    #->Oportunidades Security
    menu = General::Menu.find_or_create_by(
      title: "Oportunidades Security",
      description: "Oportunidades Security",
      css_class: "#34444",
      link: "",
      priority: nil,
      parent_id: menu_2.id,
    )
    opportunity = General::Menu.find_by_title("Oportunidades Security")
    #Cargos disponibles
    menu = General::Menu.find_or_create_by(
      title: "Cargos disponibles",
      description: "Cargos disponibles",
      css_class: "#38899",
      link: "https://misecurity.exa.cl/job_market",
      priority: nil,
      parent_id: opportunity.id,
    )
    #Referidos
    menu = General::Menu.find_or_create_by(
      title: "Referidos",
      description: "Referidos",
      css_class: "#311222",
      post_id: extra_post.id,
      priority: nil,
      parent_id: opportunity.id,
    )
    #->Programa Previsional
    menu = General::Menu.find_or_create_by(
      title: "Programa Previsional",
      description: "Programa Previsional",
      css_class: "#24224",
      link: "",
      priority: nil,
      parent_id: menu_2.id,
    )
    program = General::Menu.find_by_title("Programa Previsional")
    #Solicita tu asesoría
    menu = General::Menu.find_or_create_by(
      title: "Solicita tu asesoría",
      description: "Solicita tu asesoría",
      css_class: "#21998",
      link: "https://docs.google.com/forms/d/e/1FAIpQLScBs8L8223yfTqW_QRl8RxVn8ICRKodaHJIGqrfY9m5yRxtfg/viewform",
      priority: nil,
      parent_id: program.id,
    )
    #Información
    menu = General::Menu.find_or_create_by(
      title: "Información",
      description: "Información",
      css_class: "#29938",
      post_id: extra_post.id,
      priority: nil,
      parent_id: program.id,
    )
    #->Celebremos
    menu = General::Menu.find_or_create_by(
      title: "Celebremos",
      description: "Celebremos",
      css_class: "#64220",
      link: "",
      priority: nil,
      parent_id: menu_2.id,
    )
    celebrate = General::Menu.find_by_title("Celebremos")
    #Nacimientos
    menu = General::Menu.find_or_create_by(
      title: "Nacimientos",
      description: "Nacimientos",
      css_class: "#67778",
      link: "celebremos-nacimientos",
      priority: nil,
      parent_id: celebrate.id,
    )
    #Cumpleaños
    menu = General::Menu.find_or_create_by(
      title: "Cumpleaños",
      description: "Cumpleaños",
      css_class: "#67338",
      link: "celebremos-cumpleaños",
      priority: nil,
      parent_id: celebrate.id,
    )
    #Bienvenidos
    menu = General::Menu.find_or_create_by(
      title: "Bienvenidos",
      description: "Bienvenidos",
      css_class: "#62278",
      link: "celebremos-bienvenidos",
      priority: nil,
      parent_id: celebrate.id,
    )
    #->Ayuda a la comunidad
    menu = General::Menu.find_or_create_by(
      title: "Ayuda a la comunidad",
      description: "Ayuda a la comunidad",
      css_class: "#54550",
      link: "",
      priority: nil,
      parent_id: menu_2.id,
    )
    community = General::Menu.find_by_title("Ayuda a la comunidad")
    #Fundación Las Rosas
    menu = General::Menu.find_or_create_by(
      title: "Fundación Las Rosas",
      description: "Fundación Las Rosas",
      css_class: "#55258",
      post_id: extra_post.id,
      priority: nil,
      parent_id: community.id,
    )
    #Fundación Mi Parque
    menu = General::Menu.find_or_create_by(
      title: "Fundación Mi Parque",
      description: "Fundación Mi Parque",
      css_class: "#55599",
      post_id: extra_post.id,
      priority: nil,
      parent_id: community.id,
    )
    #->Puertas abiertas
    menu = General::Menu.find_or_create_by(
      title: "Puertas abiertas",
      description: "Puertas abiertas",
      css_class: "#89999",
      link: "",
      priority: nil,
      parent_id: menu_2.id,
    )
    door_open = General::Menu.find_by_title("Puertas abiertas")
    #Solicitar Puertas Abiertas
    menu = General::Menu.find_or_create_by(
      title: "Solicitar Puertas Abiertas",
      description: "Solicitar Puertas Abiertas",
      css_class: "#80003",
      post_id: extra_post.id,
      priority: nil,
      parent_id: door_open.id,
    )
    #Descripción
    menu = General::Menu.find_or_create_by(
      title: "Descripción",
      description: "Descripción",
      css_class: "#82939",
      post_id: extra_post.id,
      priority: nil,
      parent_id: door_open.id,
    )
    #->Cultura Corporativa
    menu = General::Menu.find_or_create_by(
      title: "Cultura Corporativa",
      description: "Cultura Corporativa",
      css_class: "#65677",
      link: "",
      priority: nil,
      parent_id: menu_2.id,
    )
    sporty = General::Menu.find_by_title("Cultura Corporativa")

    #Tiempo libre
    General::Menu.create(
      title: "Tiempo libre",
      description: "Tiempo libre",
      css_class: "#11110",
      link: "",
      priority: nil,
      parent_id: menu_2.id,
    )
    free_time = General::Menu.find_by_title("Tiempo libre")
    #Avisos clasificados
    menu = General::Menu.find_or_create_by(
      title: "Avisos clasificados",
      description: "Avisos clasificados",
      css_class: "#11100",
      link: "avisos-clasificados",
      priority: nil,
      parent_id: free_time.id,
    )
    #Biblioteca y ludoteca
    menu = General::Menu.find_or_create_by(
      title: "Biblioteca y ludoteca",
      description: "Biblioteca y ludoteca",
      css_class: "#12000",
      post_id: extra_post.id,
      priority: nil,
      parent_id: free_time.id,
    )
    #Jugar y aprender
    menu = General::Menu.find_or_create_by(
      title: "Jugar y aprender",
      description: "Jugar y aprender",
      css_class: "#19300",
      post_id: extra_post.id,
      priority: nil,
      parent_id: free_time.id,
    )
    #Ser +
    menu = General::Menu.find_or_create_by(
      title: "Ser +",
      description: "Ser +",
      css_class: "#12333",
      post_id: extra_post.id,
      priority: nil,
      parent_id: free_time.id,
    )
    #Concursos de cuentos
    menu = General::Menu.find_or_create_by(
      title: "Concursos de cuentos",
      description: "Concursos de cuentos",
      css_class: "#14559",
      post_id: extra_post.id,
      priority: nil,
      parent_id: free_time.id,
    )
    #Concursos de fotografía
    menu = General::Menu.find_or_create_by(
      title: "Concursos de fotografía",
      description: "Concursos de fotografía",
      css_class: "#15277",
      post_id: extra_post.id,
      priority: nil,
      parent_id: free_time.id,
    )
    #Concurso de pintura
    menu = General::Menu.find_or_create_by(
      title: "Concurso de pintura",
      description: "Concurso de pintura",
      css_class: "#13447",
      post_id: extra_post.id,
      priority: nil,
      parent_id: free_time.id,
    )
    #Concuros Papá Espíritu Security
    menu = General::Menu.find_or_create_by(
      title: "Concuros Papá Espíritu Security",
      description: "Concuros Papá Espíritu Security",
      css_class: "#12222",
      post_id: extra_post.id,
      priority: nil,
      parent_id: free_time.id,
    )
    ################################################ TÉRMINO INFORMADOS

    #->Mis beneficios
    menu = General::Menu.find_or_create_by(
      title: "Bonos",
      description: "Bonos",
      css_class: "#y32233",
      link: "",
      priority: nil,
      parent_id: menu_3.id,
    )
    bonus = General::Menu.find_by_title("Bonos")
    menu = General::Menu.find_or_create_by(
      title: "Vacaciones",
      description: "Vacaciones",
      css_class: "#y32571",
      post_id: extra_post.id,
      priority: nil,
      parent_id: bonus.id,
    )
    menu = General::Menu.find_or_create_by(
      title: "Bono Auxiliar de Párvulo Materno",
      description: "Bono Auxiliar de Párvulo Materno",
      css_class: "#y32571",
      post_id: extra_post.id,
      priority: nil,
      parent_id: bonus.id,
    )
    menu = General::Menu.find_or_create_by(
      title: "Bono Auxiliar de Párvulo Paterno",
      description: "Bono Auxiliar de Párvulo Paterno",
      css_class: "#366s12",
      post_id: extra_post.id,
      priority: nil,
      parent_id: bonus.id,
    )
    menu = General::Menu.find_or_create_by(
      title: "Sala Cuna",
      description: "Sala Cuna",
      css_class: "#334d12",
      post_id: extra_post.id,
      priority: nil,
      parent_id: bonus.id,
    )
    menu = General::Menu.find_or_create_by(
      title: "Jardín Infantil",
      description: "Jardín Infantil",
      css_class: "#124dd2",
      post_id: extra_post.id,
      priority: nil,
      parent_id: bonus.id,
    )
    menu = General::Menu.find_or_create_by(
      title: "Nacimiento",
      description: "Nacimiento",
      css_class: "#2930dj",
      post_id: extra_post.id,
      priority: nil,
      parent_id: bonus.id,
    )
    menu = General::Menu.find_or_create_by(
      title: "Matrimonio",
      description: "Matrimonio",
      css_class: "#b2310o",
      post_id: extra_post.id,
      priority: nil,
      parent_id: bonus.id,
    )
    menu = General::Menu.find_or_create_by(
      title: "Unión Civil",
      description: "Unión Civil",
      css_class: "#34949j",
      post_id: extra_post.id,
      priority: nil,
      parent_id: bonus.id,
    )
    menu = General::Menu.find_or_create_by(
      title: "Fallecimiento",
      description: "Fallecimiento",
      css_class: "#109220",
      post_id: extra_post.id,
      priority: nil,
      parent_id: bonus.id,
    )
    menu = General::Menu.find_or_create_by(
      title: "Escolaridad",
      description: "Escolaridad",
      css_class: "#a81123",
      post_id: extra_post.id,
      priority: nil,
      parent_id: bonus.id,
    )
    menu = General::Menu.find_or_create_by(
      title: "Gestión Empresa",
      description: "Gestión Empresa",
      css_class: "#a81234",
      post_id: extra_post.id,
      priority: nil,
      parent_id: bonus.id,
    )
    menu = General::Menu.find_or_create_by(
      title: "Ahorro Jubilación 1+1",
      description: "Ahorro Jubilación 1+1",
      css_class: "#a89i89",
      post_id: extra_post.id,
      priority: nil,
      parent_id: bonus.id,
    )
    menu = General::Menu.find_or_create_by(
      title: "Aguinaldo Fiestas Patrias",
      description: "Aguinaldo Fiestas Patrias",
      css_class: "#a12203",
      post_id: extra_post.id,
      priority: nil,
      parent_id: bonus.id,
    )
    #->Créditos y Subsidios
    menu = General::Menu.find_or_create_by(
      title: "Créditos y Subsidios",
      description: "Créditos y Subsidios",
      css_class: "#u88899",
      link: "",
      priority: nil,
      parent_id: menu_3.id,
    )
    credit = General::Menu.find_by_title("Créditos y Subsidios")
    #Créditos Banca Empleados
    menu = General::Menu.find_or_create_by(
      title: "Créditos Banca Empleados",
      description: "Créditos Banca Empleados",
      css_class: "#r8899",
      post_id: extra_post.id,
      priority: nil,
      parent_id: credit.id,
    )
    #Subsidio Habitacional
    menu = General::Menu.find_or_create_by(
      title: "Subsidio Habitacional",
      description: "Subsidio Habitacional",
      css_class: "#w2222",
      post_id: extra_post.id,
      priority: nil,
      parent_id: credit.id,
    )
    #Seguros
    menu = General::Menu.find_or_create_by(
      title: "Seguros",
      description: "Seguros",
      css_class: "#o0293",
      link: "",
      priority: nil,
      parent_id: menu_3.id,
    )
    secure = General::Menu.find_by_title("Seguros")
    #Seguro de Salud y Catastrófico
    menu = General::Menu.find_or_create_by(
      title: "Seguro de Salud y Catastrófico",
      description: "Seguro de Salud y Catastrófico",
      css_class: "#53444",
      post_id: extra_post.id,
      priority: nil,
      parent_id: secure.id,
    )
    #Seguro de vida
    menu = General::Menu.find_or_create_by(
      title: "Seguro de vida",
      description: "Seguro de vida",
      css_class: "#59990",
      post_id: extra_post.id,
      priority: nil,
      parent_id: secure.id,
    )
    #Seguro Dental
    menu = General::Menu.find_or_create_by(
      title: "Seguro Dental",
      description: "Seguro Dental",
      css_class: "#40110",
      post_id: extra_post.id,
      priority: nil,
      parent_id: secure.id,
    )
    #Seguro Vida 24 Rentas
    menu = General::Menu.find_or_create_by(
      title: "Seguro Vida 24 Rentas",
      description: "Seguro Vida 24 Rentas",
      css_class: "#42199",
      post_id: extra_post.id,
      priority: nil,
      parent_id: secure.id,
    )
    #->Becas
    menu = General::Menu.find_or_create_by(
      title: "Becas",
      description: "Becas",
      css_class: "#33330",
      link: "",
      priority: nil,
      parent_id: menu_3.id,
    )
    scholarship = General::Menu.find_by_title("Becas")
    #Becas de estudio hijos
    menu = General::Menu.find_or_create_by(
      title: "Becas de estudio hijos",
      description: "Becas de estudio hijos",
      css_class: "#55543",
      post_id: extra_post.id,
      priority: nil,
      parent_id: scholarship.id,
    )
    #Becas de estudio para empleados
    menu = General::Menu.find_or_create_by(
      title: "Becas de estudio para empleados",
      description: "Becas de estudio para empleados",
      css_class: "#53321",
      post_id: extra_post.id,
      priority: nil,
      parent_id: scholarship.id,
    )
    #->Tiempo Libre
    General::Menu.create(
      title: "Tiempo Libre",
      description: "Beneficios Tiempo Libre",
      css_class: "#o0293",
      link: "",
      priority: nil,
      parent_id: menu_3.id,
    )
    b_free_time = General::Menu.find_by_description("Beneficios Tiempo Libre")
    #Jornada reducida (viernes)
    menu = General::Menu.find_or_create_by(
      title: "Jornada reducida (viernes)",
      description: "Jornada reducida (viernes)",
      css_class: "#19384",
      post_id: extra_post.id,
      priority: nil,
      parent_id: b_free_time.id,
    )
    #24 hrs para algo importante
    menu = General::Menu.find_or_create_by(
      title: "24 hrs para algo importante",
      description: "24 hrs para algo importante",
      css_class: "#18299",
      post_id: extra_post.id,
      priority: nil,
      parent_id: b_free_time.id,
    )
    #Vacaciones temporada baja
    menu = General::Menu.find_or_create_by(
      title: "Vacaciones temporada baja",
      description: "Vacaciones temporada baja",
      css_class: "#17283",
      post_id: extra_post.id,
      priority: nil,
      parent_id: b_free_time.id,
    )
    #Día Libre para cambio de casa
    menu = General::Menu.find_or_create_by(
      title: "Día Libre para cambio de casa",
      description: "Día Libre para cambio de casa",
      css_class: "#12900",
      post_id: extra_post.id,
      priority: nil,
      parent_id: b_free_time.id,
    )
    #Días adicionales de vacaciones
    menu = General::Menu.find_or_create_by(
      title: "Días adicionales de vacaciones",
      description: "Días adicionales de vacaciones",
      css_class: "#14899",
      post_id: extra_post.id,
      priority: nil,
      parent_id: b_free_time.id,
    )
    #Horarios de salida en días especiales
    menu = General::Menu.find_or_create_by(
      title: "Horarios de salida en días especiales",
      description: "Horarios de salida en días especiales",
      css_class: "#12936",
      post_id: extra_post.id,
      priority: nil,
      parent_id: b_free_time.id,
    )
    #Examen de Grado
    menu = General::Menu.find_or_create_by(
      title: "Examen de Grado",
      description: "Examen de Grado",
      css_class: "#11190",
      post_id: extra_post.id,
      priority: nil,
      parent_id: b_free_time.id,
    )
    #Exámenes Preventivos
    menu = General::Menu.find_or_create_by(
      title: "Exámenes Preventivos",
      description: "Exámenes Preventivos",
      css_class: "#13403",
      post_id: extra_post.id,
      priority: nil,
      parent_id: b_free_time.id,
    )
    #->Familia
    menu = General::Menu.find_or_create_by(
      title: "Familia",
      description: "Familia",
      css_class: "#400jk3",
      link: "",
      priority: nil,
      parent_id: menu_3.id,
    )
    family = General::Menu.find_by_title("Familia")
    #Post Natal Paterno
    menu = General::Menu.find_or_create_by(
      title: "Post Natal Paterno",
      description: "Post Natal Paterno",
      css_class: "#400339",
      post_id: extra_post.id,
      priority: nil,
      parent_id: family.id,
    )
    #Regreso Paulatino Materno
    menu = General::Menu.find_or_create_by(
      title: "Regreso Paulatino Materno",
      description: "Regreso Paulatino Materno",
      css_class: "#49000",
      post_id: extra_post.id,
      priority: nil,
      parent_id: family.id,
    )
    #Securitylandia Verano - Invierno
    menu = General::Menu.find_or_create_by(
      title: "Securitylandia Verano - Invierno",
      description: "Securitylandia Verano - Invierno",
      css_class: "#444555",
      post_id: extra_post.id,
      priority: nil,
      parent_id: family.id,
    )
    #Tardes de Invierno
    menu = General::Menu.find_or_create_by(
      title: "Tardes de Invierno",
      description: "Tardes de Invierno",
      css_class: "#446788",
      post_id: extra_post.id,
      priority: nil,
      parent_id: family.id,
    )
    #Premio Excelencia Académica
    menu = General::Menu.find_or_create_by(
      title: "Premio Excelencia Académica",
      description: "Premio Excelencia Académica",
      css_class: "#46777",
      post_id: extra_post.id,
      priority: nil,
      parent_id: family.id,
    )
    #Premio PSU
    menu = General::Menu.find_or_create_by(
      title: "Premio PSU",
      description: "Premio PSU",
      css_class: "#43989",
      post_id: extra_post.id,
      priority: nil,
      parent_id: family.id,
    )
    #->Celebrando
    menu = General::Menu.find_or_create_by(
      title: "Celebrando",
      description: "Celebrando",
      css_class: "#o0293",
      link: "",
      priority: nil,
      parent_id: menu_3.id,
    )
    celebrating = General::Menu.find_by_title("Celebrando")
    #Cumpleaños
    menu = General::Menu.find_or_create_by(
      title: "Cumpleaños",
      description: "Cumpleaños",
      css_class: "#54321",
      post_id: extra_post.id,
      priority: nil,
      parent_id: celebrating.id,
    )
    #Fiesta Fin de Año
    menu = General::Menu.find_or_create_by(
      title: "Fiesta Fin de Año",
      description: "Fiesta Fin de Año",
      css_class: "#54666",
      post_id: extra_post.id,
      priority: nil,
      parent_id: celebrating.id,
    )
    #Paseo Grupo Security
    menu = General::Menu.find_or_create_by(
      title: "Paseo Grupo Security",
      description: "Paseo Grupo Security",
      css_class: "#57888",
      post_id: extra_post.id,
      priority: nil,
      parent_id: celebrating.id,
    )
    #Fiestas Patrias
    menu = General::Menu.find_or_create_by(
      title: "Fiestas Patrias",
      description: "Fiestas Patrias",
      css_class: "#54321",
      post_id: extra_post.id,
      priority: nil,
      parent_id: celebrating.id,
    )
    #Nacimientos mini Security
    menu = General::Menu.find_or_create_by(
      title: "Nacimientos mini Security",
      description: "Nacimientos mini Security",
      css_class: "#51113",
      post_id: extra_post.id,
      priority: nil,
      parent_id: celebrating.id,
    )
    #Regalo Inicio año escolar
    menu = General::Menu.find_or_create_by(
      title: "Regalo Inicio año escolar",
      description: "Regalo Inicio año escolar",
      css_class: "#50099",
      post_id: extra_post.id,
      priority: nil,
      parent_id: celebrating.id,
    )
    #Pascua de Resurrección
    menu = General::Menu.find_or_create_by(
      title: "Pascua de Resurrección",
      description: "Pascua de Resurrección",
      css_class: "#56697",
      post_id: extra_post.id,
      priority: nil,
      parent_id: celebrating.id,
    )
    #Regalo de Navidad para hijos
    menu = General::Menu.find_or_create_by(
      title: "Regalo de Navidad para hijos",
      description: "Regalo de Navidad para hijos",
      css_class: "#56666",
      post_id: extra_post.id,
      priority: nil,
      parent_id: celebrating.id,
    )
    #Regalo Navidad con sentido
    menu = General::Menu.find_or_create_by(
      title: "Regalo Navidad con sentido",
      description: "Regalo Navidad con sentido",
      css_class: "#54111",
      post_id: extra_post.id,
      priority: nil,
      parent_id: celebrating.id,
    )
    #Regalo Día de la madre
    menu = General::Menu.find_or_create_by(
      title: "Regalo Día de la madre",
      description: "Regalo Día de la madre",
      css_class: "#55446",
      post_id: extra_post.id,
      priority: nil,
      parent_id: celebrating.id,
    )
    #Regalo Día de padre
    menu = General::Menu.find_or_create_by(
      title: "Regalo Día de padre",
      description: "Regalo Día de padre",
      css_class: "#51116",
      post_id: extra_post.id,
      priority: nil,
      parent_id: celebrating.id,
    )
    #Regalo Día del abuelo
    menu = General::Menu.find_or_create_by(
      title: "Regalo Día del abuelo",
      description: "Regalo Día del abuelo",
      css_class: "#59998",
      post_id: extra_post.id,
      priority: nil,
      parent_id: celebrating.id,
    )
    #Regalo Día de la mujer
    menu = General::Menu.find_or_create_by(
      title: "Regalo Día de la mujer",
      description: "Regalo Día de la mujer",
      css_class: "#58889",
      post_id: extra_post.id,
      priority: nil,
      parent_id: celebrating.id,
    )
    #Regalo Día del abuelo
    menu = General::Menu.find_or_create_by(
      title: "Regalo Día del abuelo",
      description: "Regalo Día del abuelo",
      css_class: "#53428",
      post_id: extra_post.id,
      priority: nil,
      parent_id: celebrating.id,
    )
    #Regalo Pasamos Agosto
    menu = General::Menu.find_or_create_by(
      title: "Regalo Pasamos Agosto",
      description: "Regalo Pasamos Agosto",
      css_class: "#51222",
      post_id: extra_post.id,
      priority: nil,
      parent_id: celebrating.id,
    )
    #Día de la Secretaria
    menu = General::Menu.find_or_create_by(
      title: "Día de la Secretaria",
      description: "Día de la Secretaria",
      css_class: "#53339",
      post_id: extra_post.id,
      priority: nil,
      parent_id: celebrating.id,
    )
    #->Programa Yo Elijo Salud y Sustentabilidad
    menu = General::Menu.find_or_create_by(
      title: "Programa Yo Elijo Salud y Sustentabilidad",
      description: "Programa Yo Elijo Salud y Sustentabilidad",
      css_class: "#88863",
      link: "",
      priority: nil,
      parent_id: menu_3.id,
    )
    healthy = General::Menu.find_by_title("Programa Yo Elijo Salud y Sustentabilidad")
    #Fun Friday´s
    menu = General::Menu.find_or_create_by(
      title: "Fun Fridays",
      description: "Fun Fridays",
      css_class: "#53339",
      post_id: extra_post.id,
      priority: nil,
      parent_id: healthy.id,
    )
    #Cuida tu Salud - Exámenes preventivos
    menu = General::Menu.find_or_create_by(
      title: "Cuida tu Salud - Exámenes preventivos",
      description: "Cuida tu Salud - Exámenes preventivos",
      css_class: "#59579",
      post_id: extra_post.id,
      priority: nil,
      parent_id: healthy.id,
    )
    #Construcción de la Plaza
    menu = General::Menu.find_or_create_by(
      title: "Construcción de la Plaza",
      description: "Construcción de la Plaza",
      css_class: "#55677",
      post_id: extra_post.id,
      priority: nil,
      parent_id: healthy.id,
    )
    #Clases de cueca
    menu = General::Menu.find_or_create_by(
      title: "Clases de cueca",
      description: "Clases de cueca",
      css_class: "#53444",
      post_id: extra_post.id,
      priority: nil,
      parent_id: healthy.id,
    )
    #Colación de Embarazadas
    menu = General::Menu.find_or_create_by(
      title: "Colación de Embarazadas",
      description: "Colación de Embarazadas",
      css_class: "#51110",
      post_id: extra_post.id,
      priority: nil,
      parent_id: healthy.id,
    )
    #Actividades deportivas
    menu = General::Menu.find_or_create_by(
      title: "Actividades deportivas",
      description: "Actividades deportivas",
      css_class: "#52020",
      post_id: extra_post.id,
      priority: nil,
      parent_id: healthy.id,
    )
    #Charlas
    menu = General::Menu.find_or_create_by(
      title: "Charlas",
      description: "Charlas",
      css_class: "#56667",
      post_id: extra_post.id,
      priority: nil,
      parent_id: healthy.id,
    )
    #-> Convenios generales
    menu = General::Menu.find_or_create_by(
      title: "Convenios generales",
      description: "Convenios generales",
      css_class: "#32099",
      link: "",
      priority: nil,
      parent_id: menu_3.id,
    )
    general = General::Menu.find_by_title("Convenios generales")
    #Convenio Movistar
    menu = General::Menu.find_or_create_by(
      title: "Convenio Movistar",
      description: "Convenio Movistar",
      css_class: "#77889",
      post_id: extra_post.id,
      priority: nil,
      parent_id: general.id,
    )
    #Convenios Restaurantes
    menu = General::Menu.find_or_create_by(
      title: "Convenios Restaurantes",
      description: "Convenios Restaurantes",
      css_class: "#76555",
      post_id: extra_post.id,
      priority: nil,
      parent_id: general.id,
    )
    #Convenios Hoteles
    menu = General::Menu.find_or_create_by(
      title: "Convenios Hoteles",
      description: "Convenios Hoteles",
      css_class: "#71120",
      post_id: extra_post.id,
      priority: nil,
      parent_id: general.id,
    )
    #Convenios de Salud
    menu = General::Menu.find_or_create_by(
      title: "Convenios de Salud",
      description: "Convenios de Salud",
      css_class: "#77767",
      post_id: extra_post.id,
      priority: nil,
      parent_id: general.id,
    )
    #Convenios Dentales
    menu = General::Menu.find_or_create_by(
      title: "Convenios Dentales",
      description: "Convenios Dentales",
      css_class: "#788000",
      post_id: extra_post.id,
      priority: nil,
      parent_id: general.id,
    )
    #Convenios Gimnasio
    menu = General::Menu.find_or_create_by(
      title: "Convenios Gimnasio",
      description: "Convenios Gimnasio",
      css_class: "#788993",
      post_id: extra_post.id,
      priority: nil,
      parent_id: general.id,
    )
    #-> Convenios colectivos
    menu = General::Menu.find_or_create_by(
      title: "Convenios colectivos",
      description: "Convenios colectivos",
      css_class: "#32032",
      link: "",
      priority: nil,
      parent_id: menu_3.id,
    )
    puts("/////////// Fin carga de datos base para security ///////////")
  end
end
