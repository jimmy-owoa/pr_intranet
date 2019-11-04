namespace :gospel do
  desc "Get Gospel data from api"
  task gospel: :environment do
    GospelService.perform
  end
end
