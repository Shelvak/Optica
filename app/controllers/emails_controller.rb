class EmailsController < ApplicationController
 
  before_filter :requerir_user
  
  def sendemail
     to = params[:to]
     a = MyMailer.enviar(
       to, 
       params[:subject],
       params[:body]
     )
     %x{echo #{a} > email}
      if a.deliver
	     redirect_to '/emails/index', :notice => 'Emails mandados'
	else
	     redirect_to '/emails/index', :notice => 'Hubo un error =/'

  end
  end
end
