class EmailsController < ApplicationController
 
  before_filter :requerir_user
  
  def sendemail
    if MyMailer.delay.enviar(
      params[:to], 
      params[:subject],
      params[:body]
    )
      redirect_to '/emails/index', :notice => 'Emails mandados'
    else
      redirect_to '/emails/index', :notice => 'Hubo un error =/'
    end
  end
end
