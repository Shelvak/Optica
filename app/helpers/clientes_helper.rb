module ClientesHelper
  
  def edad(cump)
    @cump = cump
    return (Date.today.year - @cump.nacimiento.year.to_i)
  end
  
  
end
