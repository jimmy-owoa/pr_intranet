class General::Menu < ApplicationRecord
  searchkick text_middle: [:title, :link]
end