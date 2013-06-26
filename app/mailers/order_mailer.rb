class OrderMailer < ActionMailer::Base
  default from: "audioprintweb@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.processed.subject
  #

  def process_order(user, order)
    @user = user
    @order = order
    @greeting = "Your order has been processed and awaits shipment.  We will send you another notification when this order has been shipped."

    mail to: "#{@user.email}", bcc: "shilohkevin@gmail.com, batreyud@gmail.com", subject: "AudioPrint Order ##{@order.id} Processed"
  end

  def confirm_order(user, order)
    @user = user
    @order = order
    @greeting = "This is a confirmation email to let you know we have received your order.  If you need to make changes to this order please visit #{url_for(@order)}."

    mail to: "#{@user.email}", bcc: "shilohkevin@gmail.com, batreyud@gmail.com", subject: "AudioPrint Order ##{@order.id} Confirmation"
  end

  def ship_order(user, order)
    @user = user
    @order = order
    @greeting = "This is a confirmation email to let you know we have received your order.  If you need to make changes to this order please visit #{url_for(@order)}."

    mail to: "#{@user.email}", bcc: "shilohkevin@gmail.com, batreyud@gmail.com", subject: "AudioPrint Order ##{@order.id} has Shipped!"
  end
end
