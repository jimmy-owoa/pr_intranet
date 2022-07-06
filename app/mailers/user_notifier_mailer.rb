class UserNotifierMailer < ApplicationMailer
  default from: 'Centro de ayuda <centrodeayuda@email.cl>'

  # send a signup email to the user, pass in the user object that   contains the user's email address
  def send_signup_email(user)
    @user = user
    mail(:to => @user.email,
         :subject => "Thanks for signing up for our amazing app")
  end

  # UserNotifierMailer.send_test("jeremias@exaconsultores.cl").deliver
  def send_test(email)
    mail(to: email, subject: "Test")
  end

  def send_birth_approved(email)
    mail(to: email, subject: "Tu nacimiento ha sido aprobado")
  end

  def send_birth_not_approved(email)
    mail(to: email, subject: "Tu nacimiento ha sido rechazado")
  end

  def send_product_approved(email, name, product_id)
    @name = name
    @product_id = product_id
    mail(to: email, subject: "Tu aviso clasificado ha sido aprobado")
  end

  def send_product_not_approved(email)
    mail(to: email, subject: "Tu aviso clasificado ha sido rechazado")
  end

  def send_image_profile_changed(email)
    mail(to: email, subject: "Tu foto de perfil ha sido aprobada")
  end

  def send_avatar_not_approved(email)
    mail(to: email, subject: "Tu foto de perfil ha sido rechazada")
  end

  def send_survey_answered(email, answers, survey_name)
    @answers = answers
    @survey_name = survey_name
    mail(to: email, subject: "Encuesta respondida")
  end

  def send_survey_created(email, survey_id)
    @survey_id = survey_id
    mail(to: email, subject: "Encuesta Asignada")
  end

  def notification_new_ticket(ticket, user)
    emails = ticket.subcategory.category.assistants.map(&:email)
    @ticket = ticket
    @boss_name = General::User.find_by(id_exa: ticket.user.id_exa_boss).full_name
    @user = user
    @subcategory = @ticket.subcategory
    mail(to: emails, subject: "Nuevo Caso #{@subcategory.category.name}")
  end

  def notification_ticket_approved_to_boss(ticket, user)
    email_boss = General::User.find_by(id_exa: user.id_exa_boss).email
    @ticket = ticket
    @user = user
    @subcategory = @ticket.subcategory
    mail(to: email_boss, subject: 'Has aprobado un caso')
  end

  def notification_ticket_approved_to_user(ticket, user)
    email_user = user.email
    @ticket = ticket
    @user = user
    @subcategory = @ticket.subcategory
    mail(to: email_user, subject: 'Solicitud de Caso aprobada')
  end

  def notification_ticket_rejected_to_boss(ticket, user)
    email_boss = General::User.find_by(id_exa: user.id_exa_boss).email
    @ticket = ticket
    @user = user
    @subcategory = @ticket.subcategory
    mail(to: email_boss, subject: 'has rechazado un caso')
  end

  def notification_ticket_rejected_to_user(ticket, user)
    email_user = user.email
    @ticket = ticket
    @user = user
    @subcategory = @ticket.subcategory
    mail(to: email_user, subject: 'Solicitud de Caso rechazada')
  end

  def notification_new_message_user(ticket, message)
    @ticket = ticket
    @message = message
    mail(to: ticket.assistant.email, subject: "Nuevo mensaje en caso ##{ticket.id}")
  end

  def notification_new_message_assistant(ticket, message)
    @ticket = ticket
    @message = message
    mail(to: ticket.user.email, subject: "Nuevo mensaje en caso ##{ticket.id}")
  end

  def notification_ticket_close(ticket)
    @ticket = ticket
    @subcategory = @ticket.subcategory
    mail(to: ticket.user.email, subject: "Caso ##{ticket.id} ha sido resuelto")
  end

  # notificaciones rendicion de gastos

  # notificacion al supervisor para poder aprobar o rechazar una rendición
  def notification_new_request_boss(request) 
    @request = request
    email_boss = General::User.find_by(id_exa: @request.user.id_exa_boss).email
    #encrypt
    key = Rails.application.credentials[:secret_key_base][0..31]
    crypt = ActiveSupport::MessageEncryptor.new(key)
    @encrypted_data = Base64.strict_encode64(crypt.encrypt_and_sign({id: @request.id}))
    @link_index = "localhost:8000/rendicion-gastos/review/#{@encrypted_data }"
    mail(to: email_boss, subject: 'Nueva rendición de gastos por aprobar')
  end

  # notificacion para el supervisor, aprobo una rendicion
  def notification_request_approved_to_boss(request)
    email_boss = General::User.find_by(id_exa: request.user.id_exa_boss).email
    @request = request
    mail(to: email_boss, subject: 'Has aprobado una rendición de gastos')
  end

  # notificacion para el usuario, rendicicion aprobada por el supervisor
  def notification_request_approved_to_user(request)
    email_user = request.user.email
    @request = request
    mail(to: email_user, subject: 'Solicitud de rendición aprobada')
  end

  # notificacion a los assistentes de la rendición 
  def notification_new_request(request)
    emails = request.country.assistants.map(&:email)
    @request = request
    @boss_name = General::User.find_by(id_exa: request.user.id_exa_boss).full_name
    mail(to: emails, subject: "Nueva Rendición de gastos #{@request.id}")
  end

  # notificacion para el usuarío - rendicion rechazada por el supervisor
  def notification_request_rejected(request)
    email = request.user.email
    @request = request
    mail(to: email, subject: "Rendición de gastos rechazada")
  end
  # notificacion para el supervisor - rechazo una rendicion de gastos
  def notification_request_rejected_to_boss(request)
    email_boss = General::User.find_by(id_exa: request.user.id_exa_boss).email
    @request = request
    mail(to: email_boss, subject: "Rendición de gastos rechazada")
  end
  # rendicion cerrada 
  def notification_request_close(request)
    @request = ticket
    mail(to: request.user.email, subject: "Caso ##{request.id} ha sido resuelto")
  end
end