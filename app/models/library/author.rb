class Library::Author < ApplicationRecord
    has_many :books
end
