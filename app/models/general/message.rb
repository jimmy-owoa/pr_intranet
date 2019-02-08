class General::Message < ApplicationRecord
    has_one_attached :image
    MESSAGE_TYPES = [['Cumpleaños', 'birthdays'], ['Bienvenidos', 'welcomes'], ['General', 'general']]

    def get_name_message_types
        MESSAGE_TYPES.find { |s| s[1] == self.message_type }[0]
    end
end
