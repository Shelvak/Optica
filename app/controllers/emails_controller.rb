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

    i = 0

    emails.each_slice(400) do |email_group|
      interval = (1.hour * i) + (10.minutes * i)
      MyMailer.delay_for(interval).enviar(
        email_group,
        params[:subject],
        params[:body]
      )
      i += 1
    end

    redirect_to '/emails/index', notice: "Enviando #{emails.size} emails"
  end
end
