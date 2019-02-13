class General::Santoral < ApplicationRecord

    def self.date_santoral
        where(santoral_day: Date.today.strftime('%m-%d'))
    end

end
