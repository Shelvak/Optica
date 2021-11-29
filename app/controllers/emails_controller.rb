class EmailsController < ApplicationController

  before_action :requerir_user

  def index
    @client = Cliente.find(params[:id]) if params[:id]

    @sidekiq_online = `ps aux |grep -v "grep" |grep -i sidekiq |wc -l`.to_i.positive?
  end

  def sendemail
    to = params[:to]
    emails = case to
             when /\d+/
               Cliente.where(id: to).pluck(:email)
             when 'Todos'
               Cliente.all.pluck(:email)
             when 'Flotantes'
               Cliente.flotantes.or(Cliente.ambos_lentes).pluck(:email)
             when 'Contacto'
               Cliente.contacto.or(Cliente.ambos_lentes).pluck(:email)
             when 'Lejos'
               Cliente.lejos.or(Cliente.ambas_distancias).pluck(:email)
             when 'Cerca'
               Cliente.cerca.or(Cliente.ambas_distancias).pluck(:email)
             when 'Multifocales'
               Cliente.multifocal.pluck(:email)
             when 'Flotantes - Lejos'
               [
                 Cliente.flotantes.lejos.pluck(:email),
                 Cliente.flotantes.ambas_distancias.pluck(:email)
               ]
             when 'Flotantes - Cerca'
               [
                 Cliente.flotantes.cerca.pluck(:email),
                 Cliente.flotantes.ambas_distancias.pluck(:email)
               ]
             when 'Flotantes - Multifocales'
               Cliente.flotantes.multifocal.pluck(:email)
             end.flatten.uniq.reject(&:blank?)

    emails.each do |email|
      MyMailer.delay_for(10.seconds).enviar(
        [email],
        params[:subject],
        params[:body]
      )
    end

    redirect_to '/emails/index', notice: "Enviando #{emails.size} emails"
  end
end
