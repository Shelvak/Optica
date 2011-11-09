class ClientesController < ApplicationController
  # GET /clientes
  # GET /clientes.json
  def index
    @clientes = Cliente.order('apellido DESC', 'nombre DESC').paginate(page: params[:page], per_page: 15)
    @clientes.each do |clien|
      @cliente = clien
      mes = @cliente.nacimiento.to_s.split('-')[1].to_i
      dia = @cliente.nacimiento.to_s.split('-')[2].to_i
      if mes == Date.today.month
        if (dia == Date.today.day.to_i && dia <= 7.days.from_now.to_date.to_s.split('-')[2].to_i)
          if @cumples.nil? 
            @cumples = Array.new
            @cumples << @cliente
          else
          @cumples << @cliente
          end
        end
      end
    end
   
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @clientes }
    end
  end

  # GET /clientes/1
  # GET /clientes/1.json
  def show
    @cliente = Cliente.find(params[:id])
    @historiales = Historial.where('cliente_id = ?', "#{@cliente.id}").order(
      'created_at DESC').paginate(page: params[:page], per_page: 10)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @cliente }
    end
  end

  # GET /clientes/new
  # GET /clientes/new.json
  def new
    @cliente = Cliente.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @cliente }
    end
  end

  # GET /clientes/1/edit
  def edit
    @cliente = Cliente.find(params[:id])
  end

  # POST /clientes
  # POST /clientes.json
  def create
    @cliente = Cliente.new(params[:cliente])

    respond_to do |format|
      if @cliente.save
        format.html { redirect_to @cliente, notice: 'Cliente creado =)' }
        format.json { render json: @cliente, status: :created, location: @cliente }
      else
        format.html { render action: "new" }
        format.json { render json: @cliente.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /clientes/1
  # PUT /clientes/1.json
  def update
    @cliente = Cliente.find(params[:id])

    respond_to do |format|
      if @cliente.update_attributes(params[:cliente])
        format.html { redirect_to @cliente, notice: 'Cliente actualizado ^^' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @cliente.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clientes/1
  # DELETE /clientes/1.json
  def destroy
    @cliente = Cliente.find(params[:id])
    @cliente.destroy

    respond_to do |format|
      format.html { redirect_to clientes_url }
      format.json { head :ok }
    end
  end
  
  
  def autocompletar
    @clientes = Cliente.buscar(params[:term]).limit(5) 
    
    respond_to do |format|
      format.js { render text: @clientes.map(&:to_s) }
    end
  end
  
  def send_mail
    Emailer::deliver_contact_email(params[:email])
  end


end
