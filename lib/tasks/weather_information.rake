namespace :weather do
  desc 'weather information'
  task weather_information: :environment do
    WeatherInformationJob.perform_now({})
  end
end