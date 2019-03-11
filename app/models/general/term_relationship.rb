class General::TermRelationship < ApplicationRecord
  belongs_to :post, foreign_key: :object_id, class_name: 'News::Post', optional: true, inverse_of: :post_term_relationships
  belongs_to :attachment,  foreign_key: :object_id,class_name: 'General::Attachment', optional: true, inverse_of: :attachment_term_relationships
  belongs_to :user, foreign_key: :object_id, class_name: 'General::User', optional: true, inverse_of: :user_term_relationships
  belongs_to :term, class_name: 'General::Term', optional: true
  belongs_to :product, foreign_key: :object_id, class_name: 'Marketplace::Product', optional: true, inverse_of: :product_term_relationships  
  belongs_to :menu, foreign_key: :object_id, class_name: 'General::Menu', optional: true, inverse_of: :menu_term_relationships  , touch: true
  belongs_to :message, foreign_key: :object_id, class_name: 'General::Message', optional: true, inverse_of: :message_term_relationships 
  belongs_to :survey, foreign_key: :object_id, class_name: 'Survey::Survey', optional: true, inverse_of: :survey_term_relationships
  belongs_to :benefit, foreign_key: :object_id, class_name: 'General::Benefit', optional: true, inverse_of: :benefit_term_relationships  
end
