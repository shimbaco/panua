if Rails.env.development?
  ActionMailer::Base.smtp_settings = {
    :address              => ApplicationSettings.smtp.address,
    :port                 => ApplicationSettings.smtp.port,
    :domain               => ApplicationSettings.smtp.domain,
    :user_name            => ApplicationSettings.smtp.user_name,
    :password             => ApplicationSettings.smtp.password,
    :authentication       => ApplicationSettings.smtp.authentication,
    :enable_starttls_auto => ApplicationSettings.smtp.enable_starttls_auto
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