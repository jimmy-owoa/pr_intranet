class Helpcenter::Ticket < ApplicationRecord
  include ActionView::Helpers::DateHelper

  # validations

  # relations
  belongs_to :user, class_name: "General::User"
  belongs_to :assistant, class_name: "General::User", optional: true
  belongs_to :subcategory, class_name: "Helpcenter::Subcategory", optional: true 
  has_many :chat_messages, class_name: "Helpcenter::Message", foreign_key: :ticket_id
  has_many :satisfaction_answers, class_name: "Helpcenter::SatisfactionAnswer", foreign_key: :ticket_id
  has_many :ticket_histories, class_name: "Helpcenter::TicketHistory", foreign_key: :ticket_id
  belongs_to :replacement_user, class_name: 'General::User', optional: true
  has_many :postulaciones, class_name: "Helpcenter::JobApplication", foreign_key: :ticket_id


  # active storage
  has_many_attached :files
  # ENUM
  STATUS_COLLECTION = { "" => "Todos", "open" => "Abiertos", "attended" => "Atendidos", "recategorized" => "Recategorizado", "closed" => "Resueltos", "deleted" => "Eliminados", "waiting" => "Esperando respuesta" }.freeze

  STATUS_ES = { "open" => "abierto", "attended" => "atendiendo", "recategorized" => "recategorizado", "closed" => "resuelto", "deleted" => "eliminado", "waiting" => "esperando respuesta" }.freeze

  DIVISAS = ["ARS", "BRL", "CLP", "COP", "EUR", "MXN", "PEN", "USD", "UYU"].freeze


  enum character_of_process: { confidencial: 0, publico: 1 }
  enum recruitment_source: { concurso_interno: 0, externo: 1, promocion_interna: 2, concurso_interno_y_externo: 3 }
  enum reason_for_search: { aumento_de_dotacion: 0, cargo_nuevo: 1, practica: 2, reemplazo_dotacion_autorizada: 3, reemplazo_licencia_medica: 4, reemplazo_vacaciones: 5 }

  enum area: {
    administracion_y_recaudacion: 0,
    adquisiciones: 1,
    agentes_libres: 2,
    atencion_a_cliente: 3,
    bodega: 4,
    calidad_de_vida_cultura_y_relaciones_laborales: 5,
    capacitacion: 6,
    celula_agil_y_ecommerce: 7,
    cinerario_operacion: 8,
    comercial_cinerario: 9,
    comercial_corredora: 10,
    control_de_gestion_y_planificacion_estrategica: 11,
    desarrollo_ti: 12,
    experiencia_y_calidad_de_servicios: 13,
    fyce: 14,
    gestion_de_servicios_ti: 15,
    infraestructura_ti: 16,
    mantenimiento: 17,
    marketing: 18,
    oficina_de_sepultacion: 19,
    operaciones_y_experiencia_corredora: 20,
    personal_y_remuneraciones: 21,
    pmo_ti: 22,
    prevencion_de_riesgos: 23,
    seleccion_y_do: 24,
    sepultacion: 25,
    servicios_generales: 26,
    soporte_ti: 27,
    sostenibilidad: 28,
    tesoreria: 29
  }
  enum careers: { uno: 0, dos: 1}

  enum years_of_experience: {
    '0': 0,
    '1': 1,
    '2': 2,
    '3': 3,
    '4': 4,
    '5': 5,
    'más de 5': 6
  }

  enum company: {administradora: 0, corredora: 1, los_parques: 2, otec: 3}

  enum required_education: {
  enseñanza_media_completa: 0,
  técnico_nivel_superior: 1,
  universitaria: 2
}
enum job_location: {
  alameda_4461: 0,
  hda_201_piso_7: 1,
  los_militares: 2,
  lto_320: 3,
  pav: 4,
  pav_ii: 5,
  pco: 6,
  pph: 7,
  stc: 8,
  vespucio_1200: 9
}
enum work_schedule: {
  jornada_ft_lunes_a_viernes: 0,
  jornada_pt_sabado_domingos_y_festivos: 1,
  jornada_pt_sabado_y_domingos: 2,
  jornada_ft_lunes_a_domingos: 3
}
enum shift: {
  si: 0,
  no: 1
}
enum requires_account: {
  cuenta_correo: 0,
  cuenta_usuario: 1,
  ambas: 2
}
enum requires_computer: {
  notebook: 0,
  estacional: 1
}

enum requested_position_title: {
  abogado: 0,
  abogado_junior: 1,
  adm_sistemas_seguridad_ti: 2,
  administrador_bd: 3,
  administrador_plataforma_fyce: 4,
  administrador_sistemas_seguridad: 5,
  administrador_parque: 6,
  administrador_plataforma_contactos_fyce: 7,
  administrativa_compensaciones: 8,
  administrativo: 9,
  administrativo_cctv: 10,
  administrativo_cinerarios: 11,
  administrativo_control_interno_caja: 12,
  administrativo_control_interno_de_cajas: 13,
  administrativo_credito_recaudacion: 14,
  administrativo_abastecimiento: 15,
  administrativo_calidad_vida: 16,
  administrativo_contratos: 17,
  administrativo_coordinacion_control_pac: 18,
  administrativo_credito_recaudacion: 19,
}
enum careers: {
  ingenieria: 0,
  medicina: 1,
  derecho: 2,
  educacion: 3,
  comercio: 4,
}

enum income_composition: {
  'fija' => 0,
  'fija + variable' => 1
}

  before_create :set_status

  def set_status
    self.status = Helpcenter::TicketState.find_by(status: "open").status
  end

  def format_closed_at
    closed_at.strftime("%d/%m/%Y %H:%M hrs")
  end

  def total_time
    if closed_at.present?
      distance_of_time_in_words(created_at, closed_at)
    else
      distance_of_time_in_words(created_at, DateTime.now)
    end
  end

  def time_worked
    return "0 minutos" if attended_at.nil?

    if closed_at.present?
      distance_of_time_in_words(attended_at, closed_at)
    else
      distance_of_time_in_words(attended_at, DateTime.now)
    end
  end

  def self.take_ticket(take, ticket, current_user)
    @ticket = ticket
    if take == "true"
      assistant = current_user.id
      if @ticket.update(assistant_id: assistant, attended_at: DateTime.now, status: Helpcenter::TicketState.find_by(status: "attended").status)
        Helpcenter::TicketHistory.create(user_id: current_user.id, ticket_id: @ticket.id, ticket_state_id: Helpcenter::TicketState.find_by(status: "attended").id)
        result = { ticket: @ticket, take_ticket: true, success: true }
        return result
      else
        result = { ticket: @ticket, take_ticket: false, success: false }
        return result
      end
    else
      assistant = nil
      if @ticket.update(assistant_id: assistant, attended_at: DateTime.now, status: Helpcenter::TicketState.find_by(status: "open").status)
        Helpcenter::TicketHistory.create(user_id: current_user.id, ticket_id: @ticket.id, ticket_state_id: Helpcenter::TicketState.find_by(status: "open").id)
        result = { ticket: @ticket, take_ticket: true, success: true }
        return result
      else
        result = { ticket: @ticket, take_ticket: false, success: false }
        return result
      end
    end
  end

  def self.ticket_boss_notifications(encrypted_data)
    decrypted_back = decrypt_data(encrypted_data)
    ticket = Helpcenter::Ticket.find(decrypted_back[:ticket_id])
    request_user = ticket.user
    time_expiry = ticket.created_at + 1.year
    ticket_date = I18n.l(ticket.created_at, format: "%A, %d de %B de %Y")
    if DateTime.now >= time_expiry
      result = { ticket: ticket, state: "link_expired", user: request_user.full_name.capitalize, ticket_date: ticket_date }
      return result
    else
      if decrypted_back[:aproved_to_review] == false
        UserNotifierMailer.notification_ticket_rejected_to_boss(ticket, request_user).deliver
        UserNotifierMailer.notification_ticket_rejected_to_user(ticket, request_user).deliver
        result = { ticket: ticket, state: "rejected", user: request_user, ticket_date: ticket_date }
        ticket.destroy
        return result
      else
        ticket.update(aproved_to_review: true)
        UserNotifierMailer.notification_new_ticket(ticket, request_user).deliver
        UserNotifierMailer.notification_ticket_approved_to_boss(ticket, request_user).deliver
        UserNotifierMailer.notification_ticket_approved_to_user(ticket, request_user).deliver
        result = { ticket: ticket, state: "approved", user: request_user, ticket_date: ticket_date }
        return result
      end
    end
  end

  def self.decrypt_data(data)
    encrypted_data = Base64.decode64(data)
    key = Rails.application.credentials[:secret_key_base][0..31]
    crypt = ActiveSupport::MessageEncryptor.new(key)
    decrypted_back = crypt.decrypt_and_verify(encrypted_data)
    decrypted_back
  end
end
