class General::User < ApplicationRecord
  acts_as_nested_set
  rolify
  searchkick text_middle: [:name, :last_name, :email, :annexed]
  has_one_attached :image
  
  
  #relationships
  has_many :visits, class_name: "Ahoy::Visit"
  has_many :user_term_relationships, -> {where(object_type: 'General::User')}, class_name: 'General::TermRelationship', foreign_key: :object_id, inverse_of: :user
  has_many :terms, through: :user_term_relationships
  has_many :posts, class_name: 'News::Post', foreign_key: :user_id
  has_many :products, class_name: 'Marketplace::Product', foreign_key: :user_id
  has_many :answers, class_name: 'Survey::Answer', foreign_key: :user_id

  accepts_nested_attributes_for :terms

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  # callbacks
  after_create :assign_default_role
  before_create :only_admin?

  #scopes
  scope :show_birthday, -> { where( show_birthday: true) }
  scope :birthdays, -> { where("DATE_FORMAT(birthday, '%d/%m/%Y') = ?", Date.today.strftime("%d/%m/%Y")) }
  scope :first_welcome, -> { joins(:image_attachment).where("DATE_FORMAT(general_users.created_at, '%d/%m/%Y') = ?", Date.today.strftime("%d/%m/%Y")) }

  def assign_default_role
    add_role(:user) if roles.blank?
  end

  def only_admin?
    true if roles.map{|q| q.name }.any? "super_admin"
    false
  end    
end
