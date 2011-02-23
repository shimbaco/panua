if Rails.env.development?
  ActionMailer::Base.smtp_settings = {
    :address              => ApplicationSettings.smtp_address,
    :port                 => ApplicationSettings.smtp_port,
    :domain               => ApplicationSettings.smtp_domain,
    :user_name            => ApplicationSettings.smtp_user_name,
    :password             => ApplicationSettings.smtp_password,
    :authentication       => ApplicationSettings.smtp_authentication,
    :enable_starttls_auto => ApplicationSettings.smtp_enable_starttls_auto
  }
#elsif Rails.env.production?
#  ActionMailer::Base.smtp_settings = {
#    :address        => "smtp.sendgrid.net",
#    :port           => "25",
#    :authentication => :plain,
#    :user_name      => ENV['SENDGRID_USERNAME'],
#    :password       => ENV['SENDGRID_PASSWORD'],
#    :domain         => ENV['SENDGRID_DOMAIN']
#  }
end