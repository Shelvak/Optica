module ClientesHelper
  
  def edad(cump)
    @cump = cump
    return (Date.today.year - @cump.nacimiento.to_s.split('-')[0].to_i)
  end
  
  
end
