require "uri"
require "net/http"

class General::User < ApplicationRecord
  include ActionView::Helpers::DateHelper
  include Rails.application.routes.url_helpers
  acts_as_paranoid
  acts_as_nested_set
  rolify
  # searchkick
  validates_presence_of :name, :last_name, :email, :legal_number, :id_exa
  validates_uniqueness_of :email
  #relationships
  has_one_attached :image
  has_one_attached :new_image
  validates :image, content_type: ['image/png', 'image/jpeg']
  validates :new_image, content_type: ['image/png', 'image/jpeg']

  has_many :user_profiles, class_name: "General::UserProfile", foreign_key: :user_id, inverse_of: :user
  has_many :profiles, through: :user_profiles
  has_many :user_attributes, class_name: "General::UserAttribute", foreign_key: :user_id, inverse_of: :user

  belongs_to :country, class_name: "Location::Country", inverse_of: :users, optional: true

  devise :trackable, :timeoutable, :database_authenticatable, :omniauthable

  has_many :tickets, class_name: 'Helpcenter::Ticket', foreign_key: :user_id
  has_many :tickets_attended, class_name: 'Helpcenter::Ticket', foreign_key: :assistant_id
  has_many :chat_messages, class_name: 'Helpcenter::Message', foreign_key: :user_id
  has_many :satisfaction_answers, class_name: 'Helpcenter::SatisfactionAnswer', foreign_key: :user_id
  has_many :ticket_histories, class_name: 'Helpcenter::TicketHistory', foreign_key: :user_id

  # callbacks
  after_create :assign_default_role, :image_resize
  before_update :image_resize

  #scopes
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

  def profile_image_to_exa
    uri = URI("https://misecurity-qa3.exa.cl/user_sync_photo/update_photo")
    base64 = Base64.strict_encode64(self.image.download)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    req = Net::HTTP::Post.new(uri.path)
    req["Content-Type"] = "application/json"
    req.body = { "photo": "data:image/jpeg;base64,#{base64}", "user_code_crypted_base64": InternalAuth.encrypt(self.legal_number + self.legal_number_verification) }.to_json
    res = https.request(req)
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

  def get_full_name
    if favorite_name.present?
      "#{favorite_name} #{last_name} #{self.try(:last_name2).to_s}"
    else
      "#{name} #{last_name}"
    end
  end

  def full_name
    if last_name.present?
      name + ' ' + last_name + ' ' + self.try(:last_name2).to_s
    else
      name
    end
  end

  def assign_default_role
    add_role(:user) if roles.blank?
  end

  def set_user_attributes
    attributes = [
      ["company", self.company_id],
      ["country", self.country_id],
      ["management", self.management_id],
      ["cost_center", self.cost_center_id],
      ["gender", self.gender],
      ["position_classification", self.position_classification],
      ["employee_classification", self.employee_classification],
      ["is_boss", self.is_boss],
      ["has_children", self.has_children],
    ]
    # if self.office.present?
    #   attributes << ["office_city", self.office.commune.city_id]
    #   attributes << ["office_region", self.office.commune.city.region_id]
    #   attributes << ["office_country", self.office.commune.city.region.country_id]
    # end
    attributes.each do |attr|
      set_data_attributes(attr[0], attr[1])
    end
  end

  def help_categories
    Helpcenter::Category.joins(:roles).where(roles: self.roles)
  end

  def get_image
    image.attached? ? url_for(image) : ActionController::Base.helpers.asset_path("default_avatar.png")
  end

  def is_authorized?
    self.is_admin? || self.is_helpcenter?
  end

  def is_admin?
    self.has_role?(:admin)
  end

  def is_helpcenter?
    self.has_role?(:helpcenter)
  end

  def format_legal_number
    legal_number.present? ? "#{legal_number}-#{legal_number_verification}" : ''
  end

  def as_json_with_jwt
    json = {}
    json[:email] = self.email
    json[:name] = self.name
    json[:lastname] = self.last_name
    json[:token] = self.generate_token
    json
  end

  def as_profile_json
    json = {}
    json[:email] = self.email
    json[:name] = self.name
    json[:last_name] = self.last_name
    json
  end

  def generate_token()
    JsonWebToken.encode(id_exa: self.id_exa)
  end

  def set_office_country(office_country)
    location_country = Location::Country.where(name: office_country).first_or_create
    self.country = location_country
  end

  def average_time
    tickets = self.tickets_attended.where.not(closed_at: nil)
    return "" if tickets.empty?

    times = tickets.map {|t| t.closed_at - t.created_at}
    average_time = times.sum / times.size
    distance_of_time_in_words(average_time)
  end

  private

  def set_data_attributes(attr_name, attr_value)
    _deleted = General::UserAttribute.where(user_id: self.id, attribute_name: attr_name).where.not(value: attr_value).destroy_all
    return General::UserAttribute.where(user_id: self.id, attribute_name: attr_name, value: attr_value).first_or_create
  end
end
