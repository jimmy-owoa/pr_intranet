class General::Menu < ApplicationRecord
  searchkick word_middle: [:title, :code, :link]
end