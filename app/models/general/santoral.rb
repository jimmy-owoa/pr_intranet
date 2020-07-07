class General::Santoral < ApplicationRecord
  scope :current_santoral, -> { where(santoral_day: Date.today.strftime("%m-%d")) }
  scope :get_santoral_next, -> { where(santoral_day: (Date.today + 1.days).strftime("%m-%d")) }

  scope :get_santoral, ->(date) { where(santoral_day: date.strftime("%m-%d")).last }

  def self.as_json_with_today
    gospel = Religion::Gospel.gospel_today
    unnecessary_text = "Para recibir cada mañana el Evangelio por correo electrónico, registrarse: <a href=\"http://evangeliodeldia.org\" target=\"_blank\">evangeliodeldia.org</a>"

    santoral = {
      day: I18n.l(Date.today, format: "%A"),
      today_date: "Hoy, #{I18n.l(Date.today, format: "%d de %B").downcase}",
      tomorrow_date: "Mañana, #{I18n.l(Date.today + 1, format: "%d de %B").downcase}",
      name: self.current_santoral.first.name[0...10],
      full_name: self.current_santoral.first.name,
      tomorrow_name: self.get_santoral_next.first.name,
      gospel_title: gospel.title,
      gospel_content: gospel.content.chomp(unnecessary_text)
    }

    santoral
  end
end
