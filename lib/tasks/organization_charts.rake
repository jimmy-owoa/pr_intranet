# frozen_string_literal: true

namespace :organization_charts do
  desc 'Update organization charts'
  task update: :environment do
    begin
      puts 'Updating organization charts...'
      General::User.rebuild!
    rescue => exception
      puts "Error: #{exception}"
      UserNotifierMailer.organization_charts_error(exception).deliver_now
    end
  end
end
