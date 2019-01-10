namespace :weather do
  desc 'economic indicators'
  task weather_information: :environment do
    WeatherInformationJob.perform_now({})
  end
end