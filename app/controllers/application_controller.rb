class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery
  config.filter_parameters :password, :password_confirmation
  
  private
  def current_user_session
    @current_user_session ||= UserSession.find
  end
  
  def current_user
    @current_user ||= current_user_session && current_user_session.record
  end
    
    def requerir_admin
      unless current_user.try(:admin) == true
        flash[:notice] = "Debe ser Admin"
        store_location
        redirect_to historials_url
      end
    end
  
    def requerir_user
      unless current_user
        flash[:notice] = "Debe entrar =)"
        store_location
        redirect_to new_user_session_url
        false
      else
        expires_now
      end
    end

    def no_requerir_user
      if current_user
        flash[:notice] = "Debe salir =/"
        store_location
        redirect_to clientes_path
        false
      else
        true
      end
    end
    
     def store_location
      session[:return_to] = request.fullpath
    end
    
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
    
end
