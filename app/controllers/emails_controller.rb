class EmailsController < ApplicationController

  before_action :requerir_user

  def index
    @client = Cliente.find(params[:id]) if params[:id]
  end

  def sendemail
    to = params[:to]
    emails = case
      when to.match(/\d+/)
        Cliente.where(id: to)
      when to == 'todos'
        Cliente.all
      else
        Cliente.where(lente: to)
    end
    emails = emails.map(&:email).uniq.compact
    emails.delete('')
    emails.delete(' ')

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

    redirect_to '/emails/index', notice: 'Enviando emails'
  end
end
