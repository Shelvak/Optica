module ClientesHelper

  def edad(client)
    return '' unless client.nacimiento.present?

    years = Date.today.year - client.nacimiento.year.to_i
    if Date.today.day < client.nacimiento.day.to_i && Date.today.month <= client.nacimiento.month.to_i
      years -= 1
    end
    years
  end

end
