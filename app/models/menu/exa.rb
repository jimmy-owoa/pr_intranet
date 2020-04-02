class Menu::Exa < ApplicationRecord
  belongs_to :user, class_name: "General::User", optional: true
end
