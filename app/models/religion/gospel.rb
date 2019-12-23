class Religion::Gospel < ApplicationRecord
  scope :gospel_today, -> { where(date: Date.today).present? ? Religion::Gospel.where(date: Date.today).last : Religion::Gospel.last }

  scope :gospel_days, -> (days) { where(date: Date.today).present? ? Religion::Gospel.where(date: Date.today).last(days) : Religion::Gospel.last }

  def self.get_gospel(number)
    if number.positive?
      gospel = Religion::Gospel.where(date: Date.today + (number.days)).last
    elsif number.negative?
      gospel = Religion::Gospel.where(date: Date.today - (number.days)).last
    else
      gospel = Religion::Gospel.gospel_today
    end 
  end
end
