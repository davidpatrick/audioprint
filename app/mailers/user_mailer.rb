class UserMailer < ActionMailer::Base
  default from: "audioprintweb@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.request_account.subject
  #
  def request_account(user, account_type)
    @user = user
    @greeting = "#{@user.email} has requested for a #{account_type} account."

    mail to: "shilohkevin@gmail.com", cc: "batreyud@gmail.com", subject: "AudioPrint contributor request!"
  end

  def new_user(user)
    @user = user
    @greeting = "#{@user.email} has signed up for an account!"

    mail to: "shilohkevin@gmail.com", cc: "batreyud@gmail.com", subject: "New AudioPrint User!"
  end
end
