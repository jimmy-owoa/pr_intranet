require "uri"
require "net/http"
class General::User < ApplicationRecord
  acts_as_nested_set
  rolify
  searchkick word: [:name, :last_name, :email, :annexed]
  
  #relationships
  has_one_attached :image
  has_many :user_term_relationships, -> { where(object_type: 'General::User') }, class_name: 'General::TermRelationship', foreign_key: :object_id, inverse_of: :user
  has_many :terms, through: :user_term_relationships
  has_many :visits, class_name: "Ahoy::Visit"
  has_many :posts, class_name: 'News::Post', foreign_key: :user_id
  has_many :products, class_name: 'Marketplace::Product', foreign_key: :user_id
  has_many :answers, class_name: 'Survey::Answer', foreign_key: :user_id
  belongs_to :location, class_name: 'General::Location'
  belongs_to :benefit_group, optional: true, class_name: 'General::BenefitGroup'

  accepts_nested_attributes_for :terms

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  # callbacks
  after_create :assign_default_role, :image_resize
  before_update :image_resize
  before_create :only_admin?

  #scopes
  scope :show_birthday, -> { where( show_birthday: true) }
  scope :date_birth , -> { where("MONTH(birthday) = ?", Date.today.month ) }
  scope :birthdays, -> { where("DATE_FORMAT(birthday, '%d/%m/%Y') = ?", Date.today.strftime("%d/%m/%Y")) }
  scope :first_welcome, -> { joins(:image_attachment).where("DATE_FORMAT(general_users.created_at, '%d/%m/%Y') = ?", Date.today.strftime("%d/%m/%Y")) }

  CITIES = [
    'Antofagasta', 
    'Santiago', 
    'Copiapó', 
    'La Serena', 
    'Viña del Mar', 
    'Rancagua',
    'Talca', 
    'Concepción', 
    'Temuco', 
    'Puerto Montt'    
  ]

  def base_64_exa(file)
    uri = URI("https://misecurity-qa.exa.cl/user_sync_photo/update_photo")
    base64 = Base64.strict_encode64(open(file).to_a.join)
    http = Net::HTTP.new(uri.host, uri.port)
    # http.post(uri, base64)
  end

  def image_resize
    if self.image.attachment.present?
      avatar = self.image
      filename = avatar.filename.to_s
        attachment_path = "#{Dir.tmpdir}/#{avatar.filename}"
        File.open(attachment_path, 'wb') do |file|
          file.write(avatar.download)
          file.close
        end
        image = MiniMagick::Image.open(attachment_path)
        # if image.width ...
        image.resize "250x200>"
        image.write attachment_path
        avatar.attach(io: File.open(attachment_path), filename: filename, content_type: "image/jpg")
    end
  end
  
  def full_name
    self.name + ' ' + self.last_name
  end
  def assign_default_role
    add_role(:user) if roles.blank?
  end

  def only_admin?
    true if roles.map{|q| q.name }.any? "super_admin"
    false
  end   
  
  def self.users_welcome
    # Rails.cache.fetch('General::User.last(4)') { last(4).to_a }
    General::User.last(4)
  end

end
