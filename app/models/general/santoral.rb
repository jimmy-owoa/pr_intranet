class General::Santoral < ApplicationRecord
  scope :current, -> { where(santoral_day: Date.today.strftime('%m-%d')) }
  scope :next, -> { where(santoral_day: (Date.today + 1.days).strftime('%m-%d')) }

  scope :get_santoral, -> (date) { where(santoral_day: date.strftime('%m-%d')).last }
  scope :get_santoral_next, -> (date) { where(santoral_day: (date + 1.days).strftime('%m-%d')).last }
end
