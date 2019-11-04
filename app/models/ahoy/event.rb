class Ahoy::Event < ApplicationRecord
  include Ahoy::QueryMethods
  self.table_name = "ahoy_events"
  belongs_to :visit
  belongs_to :user, optional: true, class_name: "General::User", foreign_key: :user_id

  def check_uniq
    each do |event|
      event.properties["route"].join("/")
    end
  end
end
