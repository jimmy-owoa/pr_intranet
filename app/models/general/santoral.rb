class General::Santoral < ApplicationRecord
  scope :current, -> { where(santoral_day: Date.today.strftime('%m-%d')) }

end
