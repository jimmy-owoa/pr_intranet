class ExpenseReport::Request < ApplicationRecord
  include ActionView::Helpers::DateHelper
  #validations
  validates :description, presence: true

  # Relations
  belongs_to :user, class_name: "General::User"
  belongs_to :assistant, class_name: "General::User", optional: true
  belongs_to :society, class_name: "General::Society"
  belongs_to :request_state, class_name: "ExpenseReport::RequestState", optional: true
  belongs_to :country, class_name: "Location::Country", optional: true
  has_many :request_histories, class_name: "ExpenseReport::RequestHistory", foreign_key: :request_id
  has_many :invoices, class_name: "ExpenseReport::Invoice", foreign_key: :request_id

  has_many_attached :files

  enum divisa_id: %i[ARS BRL CLP COP EUR GBP MXN PEN USD UYU N/A]
  DIVISAS = [{"ARS": 1}, {"BRL": 2}, {"CLP": 3}, {"COP": 4} ,{"EUR": 5}, {"GBP": 6}, {"MXN": 7}, {"PEN": 8}, {"USD": 9}, {"UYU": 10}, {"N/A": 11} ].freeze
  
  enum destination_country_id: ['Argentina', 'Brasil', 'Chile', 'Colombia', 'Miami', 'México', 'Nueva York', 'Perú', 'Uruguay', 'NULL']
  COUNTRY = [{"Argentina": 0}, {"Brasil": 1}, {"Chile": 2} ,{"Colombia": 3}, {"Miami": 4} ,{"México": 5} ,{"Nueva York": 6} ,{"Perú": 7}, {"Uruguay": 8}, {"NULL": 9} ].freeze
  
  enum payment_method_id: ['Transferencia bancaria moneda local', 'Transferencia bancaria moneda extranjera', 'Abono tarjeta de crédito']
  PAYMENT_METHOD = [{"Transferencia bancaria moneda local": 1}, {"Transferencia bancaria moneda extranjera": 2}, {"Abono tarjeta de crédito": 3}].freeze

   def total_time
     if closed_at.present?
       distance_of_time_in_words(created_at, closed_at)
     else
       distance_of_time_in_words(created_at, DateTime.now)
     end
   end

   def time_worked
     return "0 minutos" if self.request_histories.nil?

     if closed_at.present?
       distance_of_time_in_words(attended_at, closed_at)
     else
       distance_of_time_in_words(created_at, DateTime.now)
     end
   end

   def attended_at
    if self.request_histories.present?
      self.request_histories.first.created_at
    end
   end

   def self.request_boss_notifications(encrypted_data)
    decrypted_back = decrypt_data(encrypted_data)
    request = ExpenseReport::Request.find(decrypted_back[:id])
    request_user = request.user
    time_expiry = request.created_at + 1.year
    request_date = I18n.l(request.created_at, format: "%A, %d de %B de %Y")
    if DateTime.now >= time_expiry
      result = { request: request, state: "link_expired", user: request_user.full_name.capitalize, request_date: request_date }
      return result
    else
      result = { request: request, user: request_user, request_date: request_date }
      return result
    end
  end

  def self.decrypt_data(data)
    encrypted_data = Base64.decode64(data)
    key = Rails.application.credentials[:secret_key_base][0..31]
    crypt = ActiveSupport::MessageEncryptor.new(key)
    decrypted_back = crypt.decrypt_and_verify(encrypted_data)
    decrypted_back
  end

  def set_state(state)
    return self.request_state_id = ExpenseReport::RequestState.find_by(name: state.downcase).id
  end
end
