class Religion::Gospel < ApplicationRecord
  scope :gospel_today, -> { where(date: Date.today).present? ? Religion::Gospel.where(date: Date.today).last : Religion::Gospel.last }

  scope :gospel_days, -> (days) { where(date: Date.today).present? ? Religion::Gospel.where(date: Date.today).last(days) : Religion::Gospel.last }

  def self.get_gospel(number)
    gospel = Religion::Gospel.where(date: Date.today + (number.days)).present? ? Religion::Gospel.where(date: Date.today + (number.days)).last : Religion::Gospel.last
  end
end
