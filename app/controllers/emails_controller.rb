class EmailsController < ApplicationController
 
#  def index
#    logger.debug { "Hola".inspect }
#  end  
  
  def sendemail 
     MyMailer.enviar(params[:to],params[:subject],params[:body]).deliver
     flash[:notice] = 'Emails mandados'
    redirect_to '/emails/index'
  end

end