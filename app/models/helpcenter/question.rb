class Helpcenter::Question < ApplicationRecord
  # validations
  validates :name, :subcategory_id, :profile_id, presence: true
  # relations
  belongs_to :profile, class_name: 'General::Profile'
  belongs_to :subcategory, class_name: 'Helpcenter::Subcategory'
  # Elasticsearch
  # searchkick
end