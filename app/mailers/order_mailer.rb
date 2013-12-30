class OrderMailer < ActionMailer::Base
  default from: "audioprintweb@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.processed.subject
  #

  def confirm_order(user, order)
    @user = user
    @order = order
    @greeting = "This is a confirmation email to let you know we have received your order. You can view the order at #{url_for(@order)}."

    mail to: "#{@user.email}", bcc: "shilohkevin@gmail.com, batreyud@gmail.com", subject: "AudioPrint Order ##{@order.id} Confirmation"
  end

  def process_order(user, order)
    @user = user
    @order = order
    @greeting = "Your order has been processed and awaits shipment.  We will send you another notification when this order has been shipped. You can view the order at #{url_for(@order)}"

    mail to: "#{@user.email}", bcc: "shilohkevin@gmail.com, batreyud@gmail.com", subject: "AudioPrint Order ##{@order.id} Processed"
  end

  def ship_order(user, order)
    @user = user
    @order = order
    @greeting = "Your order has been completed and shipped. You can view the order at #{url_for(@order)}."

    mail to: "#{@user.email}", bcc: "shilohkevin@gmail.com, batreyud@gmail.com", subject: "AudioPrint Order ##{@order.id} has Shipped!"
  end
end
