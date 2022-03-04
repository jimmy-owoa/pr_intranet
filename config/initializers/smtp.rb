ActionMailer::Base.smtp_settings = {
  address: "smtp.gmail.com",
  port: 587,
  domain: "gmail.com",
  user_name: Rails.env.production? ? "centrodeayuda@exa.cl" : "",
  password:  Rails.env.production? ? "RedExa@CA" : "",
  authentication: :login,
  enable_starttls_auto: true,
}
