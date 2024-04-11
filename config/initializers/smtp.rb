ActionMailer::Base.smtp_settings = {
  address: "smtp.gmail.com",
  port: 587,
  domain: "gmail.com",
  user_name: Rails.env.production? ? "" : "",
  password:  Rails.env.production? ? "" : "",
  authentication: :login,
  enable_starttls_auto: true,
}
