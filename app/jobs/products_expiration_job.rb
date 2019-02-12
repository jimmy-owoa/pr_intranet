class ProductsExpirationJob < ApplicationJob
  queue_as :products_expiration

  def perform(*args)
    # Do something later
    Marketplace::Product.all.each do |x|
       if x.created_at < x.expiration.days.ago 
         x.is_expired = true 
         x.save
       else
        x.is_expired = false
        x.save
       end
    end
  end
end
