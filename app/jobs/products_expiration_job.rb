class ProductsExpirationJob < ApplicationJob
  queue_as :products_expiration

  def perform(*args)
    # Do something later
    Marketplace::Product.all.each do |product|
      if !product.published_date.present? || product.published_date < product.expiration.days.ago
        product.update(is_expired: true)
      else
        product.update(is_expired: false)
      end
    end
  end
end
