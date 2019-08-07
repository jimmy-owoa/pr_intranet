class General::Santoral < ApplicationRecord
  scope :current, -> { where(santoral_day: Date.today.strftime('%m-%d')) }
  scope :next, -> { where(santoral_day: (Date.today + 1.days).strftime('%m-%d')) }
end
