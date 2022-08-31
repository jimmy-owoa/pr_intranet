# frozen_string_literal: true

namespace :users do
  desc 'Elimina todos los usuarios que no se actualizaron en la noche y que no esten protegidos'
  
  task delete_users: :environment do
    start_time = Time.now
    puts "------------- Inicio #{Date.today.strftime('%FT%T')} -------------"
    users_to_deleted = General::User.where('updated_at < ?', Date.today)
    if users_to_deleted.count > 100
      puts "------------- La tarea no se ejecuto, numero de usuarios #{users_to_deleted.count} -------------"
    else
      puts "------------- Se eliminaron los siguientes usuarios:  -------------"
      users_to_deleted.map { |u| puts "#{[ u.legal_number, u.full_name, u.id_exa]}" }
      puts "------------- #{users_to_deleted.count} usuarios eliminados-------------"
      users_to_deleted.each do |u|
      u.update(deleted_at: Time.now)
    end
  end
    end_time = Time.now
    puts "------------- Tiempo de ejecución: #{(end_time - start_time).round(2)} segundos -------------"
  end
end
  