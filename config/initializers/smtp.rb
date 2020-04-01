ActionMailer::Base.smtp_settings = {
  address: "smtp.sendgrid.net",
  port: 587,
  domain: "mi.security.cl",
  user_name: Rails.env.production? ? Rails.application.credentials.sendgrid_username : "",
  password: Rails.env.production? ? Rails.application.credentials.sendgrid_password : "",
  authentication: :login,
  enable_starttls_auto: true,
}
