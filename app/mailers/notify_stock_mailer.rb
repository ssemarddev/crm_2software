class NotifyStockMailer < ApplicationMailer
  default from: 'notificaciones2software@gmail.com'
  def alert(user, product)
    @product = product
    @user    = user
    mail(to: user.Correo, subject: 'Alerta, es esta agotando un producto!')
  end
end
