class ApplicationMailer < ActionMailer::Base
  default from: ENV["USER_MAIL"]
  layout "mailer"
end
