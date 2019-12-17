ActionMailer::Base.smtp_settings = {
  address: 'smtp.sendgrid.net',
  port: 587,
  domain: 'miintranet.exaconsultores.cl',
  user_name: Rails.env.production? ? ENV["SENDGRID_USERNAME"] : Rails.application.credentials.sendgrid_username,
  password: Rails.env.production? ? ENV["SENDGRID_PASSWORD"] : Rails.application.credentials.sendgrid_password,
  authentication: :login,
  enable_starttls_auto: true
}