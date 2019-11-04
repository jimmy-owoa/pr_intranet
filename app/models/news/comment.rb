class News::Comment < ApplicationRecord
  belongs_to :post, class_name: "News::Post"
end
