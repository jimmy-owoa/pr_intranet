class General::Santoral < ApplicationRecord\
    scope :santoral_day, -> {where(santoral_day: Date.today.strftime('%m-%d'))}
end
