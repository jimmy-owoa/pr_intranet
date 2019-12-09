require "uri"
require "net/http"

class General::User < ApplicationRecord
  acts_as_nested_set
  rolify
  searchkick
  validates_presence_of :name, :email, :legal_number, :legal_number_verification
  #relationships
  has_one_attached :image
  has_one_attached :new_image
  has_many :user_term_relationships, -> { where(object_type: "General::User") }, class_name: "General::TermRelationship", foreign_key: :object_id, inverse_of: :user
  has_many :terms, through: :user_term_relationships
  has_many :visits, class_name: "Ahoy::Visit"
  has_many :posts, class_name: "News::Post", foreign_key: :user_id
  has_many :products, class_name: "Marketplace::Product", foreign_key: :user_id
  has_many :answers, class_name: "Survey::Answer", foreign_key: :user_id
  has_many :births, class_name: "Employee::Birth", foreign_key: :user_id
  has_many :notifications, class_name: "General::Notification"
  has_many :language_levels, class_name: "PersonalData::LanguageLevel", foreign_key: :user_id, inverse_of: :user
  has_many :languages, through: :language_levels
  has_many :education_states, class_name: "PersonalData::EducationState", foreign_key: :user_id, inverse_of: :user
  has_many :education_institutions, through: :education_states
  has_many :family_members, class_name: "PersonalData::FamilyMember", foreign_key: :user_id
  has_many :user_profiles, class_name: "General::UserProfile", foreign_key: :user_id, inverse_of: :user
  has_many :user_messages, class_name: "General::UserMessage", foreign_key: :user_id, inverse_of: :user
  has_many :profiles, through: :user_profiles
  has_many :user_attributes, class_name: "General::UserAttribute", foreign_key: :user_id, inverse_of: :user

  belongs_to :location, class_name: "General::Location", inverse_of: :users, optional: true
  belongs_to :benefit_group, optional: true, class_name: "General::BenefitGroup"
  belongs_to :office, class_name: "Company::Office", inverse_of: :users, optional: true
  belongs_to :cost_center, class_name: "Company::CostCenter", inverse_of: :users, optional: true
  belongs_to :management, class_name: "Company::Management", inverse_of: :users, optional: true
  belongs_to :company, class_name: "Company::Company", inverse_of: :users, optional: true

  has_many :user_book_relationships, class_name: "General::UserBookRelationship", foreign_key: :user_id
  has_many :books, -> { distinct }, through: :user_book_relationships
  has_many :user_languages, class_name: "PersonalData::UserLanguage", foreign_key: :user_id
  has_many :language_levels, through: :user_languages
  has_many :languages, through: :user_languages

  has_many :user_educations, class_name: "PersonalData::UserEducation", foreign_key: :user_id
  has_many :education_institutions, through: :user_educations
  has_many :users, through: :user_educations

  has_many :family_members, class_name: "PersonalData::FamilyMember"

  accepts_nested_attributes_for :terms

  devise :trackable, :timeoutable, :database_authenticatable, :omniauthable, omniauth_providers: [:azure_oauth2]

  # callbacks
  after_create :assign_default_role, :image_resize
  before_update :image_resize
  before_create :only_admin?

  #scopes
  scope :show_birthday, -> { where(show_birthday: true) }
  scope :date_birth, -> { where("MONTH(birthday) = ?", Date.today.month) }
  scope :birthdays, -> { where("DATE_FORMAT(birthday, '%d/%m/%Y') = ?", Date.today.strftime("%d/%m/%Y")) }
  scope :first_welcome, -> { joins(:image_attachment).where("DATE_FORMAT(general_users.created_at, '%d/%m/%Y') = ?", Date.today.strftime("%d/%m/%Y")) }
  scope :users_birthday_today, -> { where("MONTH(birthday) = ?", Time.now.to_date.month).where("DAY(birthday) = ?", Time.now.to_date.day) }
  PERMISSION = { "todos" => "Todos", true => "Aprobados", false => "No aprobados" }

  CITIES = [
    "Antofagasta",
    "Santiago",
    "Copiapó",
    "La Serena",
    "Viña del Mar",
    "Rancagua",
    "Talca",
    "Concepción",
    "Temuco",
    "Puerto Montt",
  ]

  def search_data
    {
      full_name: "#{name} #{last_name}",
      annexed: annexed,
    }
  end

  def self.get_user_by_ln(ln_user)
    user = General::User.where(legal_number: ln_user[0...-1], legal_number_verification: ln_user[-1]).last
  end

  def self.from_omniauth(auth)
    where(email: auth.info.email).first
  end

  def self.decrypt(data, cipher_key = nil)
    cipher = OpenSSL::Cipher.new "aes-256-cbc"
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

  def is_birthday_today
    today = Date.today
    if (self.birthday.present? && self.birthday.month == today.month && self.birthday.day == today.day)
      true
    else
      false
    end
  end

  def is_entry_today
    self.date_entry == Date.today
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
      File.open(attachment_path, "wb") do |file|
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
    if self.last_name.present?
      self.name + " " + self.last_name
    else
      self.name
    end
  end

  def self.what_role?(user)
    if user.has_role?("user")
      return "user"
    elsif user.has_role?("post_admin")
      return "post_admin"
    elsif user.has_role?("super_admin")
      return "super_admin"
    elsif user.has_role?("message_admin")
      return "message_admin"
    else
      user.add_role(:user)
      return "user" if user.has_role?("user")
    end
  end

  def assign_default_role
    add_role(:user) if roles.blank?
  end

  def only_admin?
    true if roles.map { |q| q.name }.any? "super_admin"
    false
  end

  def self.users_welcome
    # Rails.cache.fetch('General::User.last(4)') { last(4).to_a }
    General::User.where(date_entry: (Date.today - 100.days)..Date.today).order("RAND()")
  end

  def get_color
    if self.company.present?
      case self.company.name.upcase
      when "BANCO SECURITY S.A.", "FACTORING SECURITY S.A.", "MANDATOS SECURITY LIMITADA"
        "#8D0C9A"
      when "TRAVEX SECURITY", "TRAVEL SECURITY S.A.", "INMOBILIARIA SECURITY S.A.", "INMOBILIARIA SECURITY SIETE", "REPRESENTACIONES SECURITY LTDA"
        "#008DCF"
      when "VALORES SECURITY S.A. COR. BOLSA", "ADM GRAL DE FONDOS SECURITY S.A.", "SECURITIZADORA SECURITY S. A.", "INMOBILIARIA CASANUESTRA", "GLOBAL SECURITY LTDA.", "ASESORIAS SECURITY S.A."
        "#FF052B"
      when "VIDA SECURITY S.A.", "CORREDORA DE SEGUROS SECURITY", "HIPOTECARIA SECURITY PRINCIPAL", "PROTECTA SECURITY", "ADM. SERVICIOS BENEFICIOS LTDA"
        "#FF6E00"
      when "GRUPO SECURITY S.A.", "CAPITAL S.A"
        "#628D36"
      else
        "#000000"
      end
    else
      "#000000"
    end
  end

  def get_messages
    messages = self.user_messages
    data = []
    birthday_messages = []
    welcome_messages = []
    messages.each do |um|
      case um.message.message_type.downcase
      when "birthdays"
        if um.user.is_birthday_today
          birthday_messages << um
        end
      when "welcomes"
        if um.user.is_entry_today
          welcome_messages << um
        end
      when "general"
        data << um
      end
    end
    data << birthday_messages.sample
    data << welcome_messages.sample
    return data.compact
  end

  def set_user_attributes
    attributes = [
      ["company", self.company_id],
      ["benefit_group", self.benefit_group_id],
      ["management", self.management_id],
      ["cost_center", self.cost_center_id],
      ["gender", self.gender],
      ["position_classification", self.position_classification],
      ["employee_classification", self.employee_classification],
      ["is_boss", self.is_boss],
      ["has_children", self.has_children],
    ]
    if self.office.present?
      attributes << ["office_city", self.office.commune.city_id]
      attributes << ["office_region", self.office.commune.city.region_id]
      attributes << ["office_country", self.office.commune.city.region.country_id]
    end
    attributes.each do |attr|
      set_data_attributes(attr[0], attr[1])
    end
  end

  private

  def set_data_attributes(attr_name, attr_value)
    _deleted = General::UserAttribute.where(user_id: self.id, attribute_name: attr_name).where.not(value: attr_value).delete_all
    return General::UserAttribute.where(user_id: self.id, attribute_name: attr_name, value: attr_value).first_or_create
  end
end
