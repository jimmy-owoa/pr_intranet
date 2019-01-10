namespace :indicators do
  desc 'economic indicators'
  task economic_indicator: :environment do
    EconomicIndicatorJob.perform_now({})
  end
end