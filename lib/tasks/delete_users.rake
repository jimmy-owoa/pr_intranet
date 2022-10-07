# frozen_string_literal: true

namespace :users do
  desc "Elimina todos los usuarios que no se actualizaron en la noche y que no esten protegidos"

  task delete_users: :environment do
    start_time = Time.now
    puts "------------- Inicio #{Date.today.strftime("%FT%T")} -------------"
    users_to_delete = General::User.where("updated_at < ?", Date.today).where.not(email: "admin@exaconsultores.cl")
    if users_to_delete.count > 50
      puts "------------- La tarea no se ejecuto, numero de usuarios #{users_to_delete.count} -------------"
    else
      puts "------------- Se eliminarán los siguientes usuarios:  -------------"
      users_to_delete.map { |u| puts "#{[u.legal_number, u.full_name, u.id_exa]}" }
      puts "------------- #{users_to_delete.count} usuarios eliminados-------------"
      users_to_delete.each do |u|
        u.update(deleted_at: Time.now)
      end
    end
    end_time = Time.now
    puts "------------- Tiempo de ejecución: #{(end_time - start_time).round(2)} segundos -------------"
  end
end
