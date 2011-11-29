class UserSessionsController < ApplicationController
 
  before_filter :no_requerir_user, :only => [:new, :create]
  before_filter :requerir_user, :only => [:destroy]
  
  
  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Bienvenido =)"
      redirect_back_or_default clientes_path
    else
      render :action => :new
    end
  end
  
  def destroy
    current_user_session.destroy
    flash[:notice] = "Salida Exitosa =D Te esperamos nuevamente"
    redirect_back_or_default new_user_session_url
  end
  
  
end
