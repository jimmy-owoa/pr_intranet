ActionMailer::Base.smtp_settings = {
  address: 'smtp.sendgrid.net',
  port: 587,
  domain: 'misecurity.elmejorlugarparatrabajar.cl',
  user_name: Rails.application.credentials.sendgrid[:username],
  password: Rails.application.credentials.sendgrid[:password],
  authentication: :login,
  enable_starttls_auto: true
}