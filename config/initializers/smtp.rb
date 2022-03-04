ActionMailer::Base.smtp_settings = {
  address: "smtp.gmail.com",
  port: 587,
  domain: "gmail.com",
  user_name: "centrodeayuda@exa.cl",
  password: "RedExa@CA",
  authentication: :login,
  enable_starttls_auto: true,
}
