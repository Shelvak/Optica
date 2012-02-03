module ClientesHelper
  
  def edad(cump)
    @cump = cump
    return (Date.today.year - @cump.nacimiento.year.to_i)
  end
  
  def edad_show(cump)
    @cump = cump
    if Date.today.day < @cump.nacimiento.day.to_i && Date.today.month <= @cump.nacimiento.month.to_i
      return Date.today.year - @cump.nacimiento.year.to_i - 1
    else
      return Date.today.year - @cump.nacimiento.year.to_i
    end
  end
  
end
