namespace :daily do
  desc 'santoral and gospel information'
  task daily_information: :environment do
    DailyInformationJob.perform_now({})
  end
end