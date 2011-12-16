# encoding: UTF-8

class EmailsController < ApplicationController
 
  before_filter :requerir_user
  
  def sendemail 
     MyMailer.enviar(params[:to],params[:subject],params[:body]).deliver
     flash[:notice] = 'Emails mandados'
    redirect_to '/emails/index'
  end

end