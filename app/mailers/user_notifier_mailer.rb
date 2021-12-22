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
    mail(to: email, subject: "Tu nacimiento ha sido rechazado”.")
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
    @user = user
    @subcategory = @ticket.subcategory
    mail(to: emails, subject: 'Nuevo caso creado')
  end

  def notification_new_ticket_boss(ticket, user) 
    boss = General::User.find_by(id: ticket.user.id_exa_boss)
    email = boss.email
    @ticket = ticket
    @subcategory = @ticket.subcategory
    mail(to: email, subject: 'Nuevo caso por aprobar')
  end
  def notification_ticket_approved_to_boss(ticket, user)
    email_boss = General::User.find(user.id_exa_boss).email
    @ticket = ticket
    @user = user
    @subcategory = @ticket.subcategory
    mail(to: email_boss, subject: 'Caso por aprobar')
  end
  def notification_ticket_approved_to_user(ticket, user)
    email_user = user.email
    @ticket = ticket
    @user = user
    @subcategory = @ticket.subcategory
    mail(to: email_user, subject: 'Caso por aprobar')
  end
  def notification_ticket_rejected_to_boss(ticket, user)
    email_boss = General::User.find(user.id_exa_boss).email
    @ticket = ticket
    @user = user
    @subcategory = @ticket.subcategory
    mail(to: email_boss, subject: 'Caso rechazado')
  end
  def notification_ticket_rejected_to_user(ticket, user)
    email_user = user.email
    @ticket = ticket
    @user = user
    @subcategory = @ticket.subcategory
    mail(to: email_user, subject: 'Caso rechazado')
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
end
