class EmailsController < ApplicationController

  before_filter :requerir_user

  def sendemail
    to = params[:to]
    emails = (
      to == 'todos' ? Cliente.all : Cliente.where(lente: to)
    ).map(&:email).uniq.compact
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

    redirect_to '/emails/index', :notice => 'Enviando emails'
  end
end
