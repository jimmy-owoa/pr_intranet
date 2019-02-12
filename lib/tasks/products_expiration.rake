namespace :products do
    task products_expiration: :environment do
        ProductsExpirationJob.perform_now({})
      end
end
