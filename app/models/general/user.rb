require "uri"
require "net/http"
class General::User < ApplicationRecord
  acts_as_nested_set
  rolify
  searchkick
  validates_presence_of :name, :email
  #relationships
  has_one_attached :image
  has_many :user_term_relationships, -> { where(object_type: 'General::User') }, class_name: 'General::TermRelationship', foreign_key: :object_id, inverse_of: :user
  has_many :terms, through: :user_term_relationships
  has_many :visits, class_name: "Ahoy::Visit"
  has_many :posts, class_name: 'News::Post', foreign_key: :user_id
  has_many :products, class_name: 'Marketplace::Product', foreign_key: :user_id
  has_many :answers, class_name: 'Survey::Answer', foreign_key: :user_id
  has_many :births, class_name: 'Employee::Birth', foreign_key: :user_id
  has_many :notifications, class_name: 'General::Notification'
  
  belongs_to :location, class_name: 'General::Location', inverse_of: :users
  belongs_to :benefit_group, optional: true, class_name: 'General::BenefitGroup'

  accepts_nested_attributes_for :terms

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :trackable

  # callbacks
  after_create :assign_default_role, :image_resize
  before_update :image_resize
  before_create :only_admin?

  #scopes
  scope :show_birthday, -> { where( show_birthday: true) }
  scope :date_birth , -> { where("MONTH(birthday) = ?", Date.today.month ) }
  scope :birthdays, -> { where("DATE_FORMAT(birthday, '%d/%m/%Y') = ?", Date.today.strftime("%d/%m/%Y")) }
  scope :first_welcome, -> { joins(:image_attachment).where("DATE_FORMAT(general_users.created_at, '%d/%m/%Y') = ?", Date.today.strftime("%d/%m/%Y")) }

  PERMISSION = {'todos' => 'Todos', true => 'Aprobados', false => 'No aprobados'}

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

  def search_data 
    {
      full_name: "#{name} #{last_name}",
      annexed: annexed
    }
  end

  def self.get_user_by_ln ln_user
    General::User.where(legal_number: ln_user[0...-1], legal_number_verification: ln_user[-1]).first
  end
  
  def self.decrypt data, cipher_key = nil
    cipher = OpenSSL::Cipher.new 'aes-256-cbc'
    cipher.decrypt
    cipher.key = cipher_key || Rails.application.secrets.cipher_key
    unescaped = CGI.unescape(data) # Se le quita el urlencode
    # se encuentran los datos el IV y del dato encriptado separados por &
    base64_data = unescaped.split("&")
    # Se descodifica de base64 cada dato
    decoded_iv = Base64.decode64(base64_data[0])
    decoded_encrypt = Base64.decode64(base64_data[1])
    cipher.iv = decoded_iv # Se carga el IV
    decrypted = cipher.update(decoded_encrypt) # Se hace el primer paso de desencriptación
    decrypted << cipher.final # Se finaliza la desencriptación
    timestamp = decrypted[-10..(decrypted.length - 1)].to_i
    now = Time.new.to_i
    if now - timestamp > -30 && now - timestamp < 30
      return decrypted[0..(decrypted.length - 11)]
    end
    return false
  end

  def base_64_exa(file)
    uri = URI("https://misecurity-qa.exa.cl/user_sync_photo/update_photo")
    base64 = Base64.strict_encode64(open(file).to_a.join)
    http = Net::HTTP.new(uri.host, uri.port)
    # http.post(uri, base64)
  end

  def self.birthday?(date)
    date.strftime("%d/%m/%Y") == Date.today.strftime("%d/%m/%Y")
  end

  def self.welcome?(id, date)
    today = Date.today.strftime("%d/%m/%Y")
    user = find(id)
    if date.present?
      date.strftime("%d/%m/%Y") == today
    else
      user.update_attributes(date_entry: today)
    end
  end

  def self.active_filter(data)
    order(id: :desc).where(["active LIKE ?", data])
  end

  def image_resize
    if self.image.attachment.present? && self.attribute_changed?(:image_id)
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
    self.name + ' ' + self.last_name + ' ' + self.last_name2
  end

  def self.what_role? user
    if user.has_role?("user")
      return "user"
    elsif user.has_role?("post_admin")
      return "post_admin"
    elsif user.has_role?("super_admin")
      return "super_admin"
    elsif user.has_role?("message_admin")
      return "message_admin"
    else
      user_r = user.add_role(:user)
      return user_r.what_role? user
    end
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
    General::User.where(date_entry: (Date.today-100.days)..Date.today).order('RAND()')
  end

  def get_color 
    case self.company
      when 'BANCO SECURITY S.A.' || 'FACTORING SECURITY S.A.' || 'MANDATOS SECURITY LIMITADA'
        '#8D0C9A'
      when 'TRAVEX SECURITY' || 'TRAVEL SECURITY S.A.' || 'INMOBILIARIA SECURITY S.A.' || 'INMOBILIARIA SECURITY SIETE' || 'REPRESENTACIONES SECURITY LTDA'
        '#008DCF'
      when 'VALORES SECURITY S.A.COR.BOLSA' || 'ADM GRAL DE FONDOS SECURITY SA' || 'SECURITIZADORA SECURITY S. A.' || 'INMOBILIARIA CASANUESTRA' || 'GLOBAL SECURITY LTDA.' || 'ASESORIAS SECURITY S.A.'
        '#FF052B'
      when 'VIDA SECURITY S.A.' || 'CORREDORA DE SEGUROS SECURITY' || 'HIPOTECARIA SECURITY PRINCIPAL' || 'PROTECTA SECURITY' || 'ADM. SERVICIOS BENEFICIOS LTDA'
        '#FF6E00'
      when 'GRUPO SECURITY S.A.' || 'CAPITAL S. A.'
        '#628D36'
      else
        "#000000"
      end
  end
end
