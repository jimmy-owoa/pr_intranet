class Religion::Gospel < ApplicationRecord
  scope :gospel_today, -> { where(date: Date.today).present? ? Religion::Gospel.where(date: Date.today).last : Religion::Gospel.last }

  scope :gospel_days, -> (days) { where(date: Date.today).present? ? Religion::Gospel.where(date: Date.today).last(days) : Religion::Gospel.last }

  def self.get_gospel(number)
    if number.positive?
      gospels = Religion::Gospel.where(date: Date.today + number.days).last
    elsif number.negative?
      gospels = Religion::Gospel.where(date: Date.today - number.days).last
    else
      gospels = "Sin Datos"
    end 
  end
end
