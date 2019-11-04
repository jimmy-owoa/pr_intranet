class UserNotifierMailer < ApplicationMailer
  default :from => "notificaciones@misecurity.cl"

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
    mail(to: email, subject: "Nacimiento aprobado")
  end

  def send_birth_not_approved(email)
    mail(to: email, subject: "Nacimiento rechazado")
  end

  def send_product_approved(email, name, product_id)
    @name = name
    @product_id = product_id
    mail(to: email, subject: "Aviso aprobado")
  end

  def send_product_not_approved(email)
    mail(to: email, subject: "Aviso rechazado")
  end
end
