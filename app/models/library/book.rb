class Library::Book < ApplicationRecord
    belongs_to :author, class_name: "Library::Author"
    belongs_to :editorial, class_name: "Library::Editorial"
    
    has_one_attached :image
end
