class ContactMailer < ActionMailer::Base
  def contact(name, email, phone, message)
    @name = name
    @email = email
    @phone = phone
    @message = message

    mail(:to => WUR['email']['to'], :subject => "WuR email from #{@email}")
  end
end
