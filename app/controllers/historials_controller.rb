class HistorialsController < ApplicationController
  # GET /historials
  # GET /historials.json
  def index
    @historials = Historial.order('created_at DESC').paginate(page: params[:page], per_page: 20)
    @contacto = Historial.where(tipolente: true).paginate(page: params[:page], per_page: 20)
    @flotante = Historial.where(tipolente: false).paginate(page: params[:page], per_page: 20)
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @historials }
    end
  end

  # GET /historials/1
  # GET /historials/1.json
  def show
    @historial = Historial.find(params[:id])
    @receta = Recete.histori(@historial.id)
     
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @historial }
    end
  end

  # GET /historials/new
  # GET /historials/new.json
  def new
    @historial = Historial.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @historial }
    end
  end

  # GET /historials/1/edit
  def edit
    @historial = Historial.find(params[:id])
  end

  # POST /historials
  # POST /historials.json
  def create
    @historial = Historial.new(params[:historial])

    respond_to do |format|
      if @historial.save
        format.html { redirect_to @historial, notice: 'Historial ha sido creado.' }
        format.json { render json: @historial, status: :created, location: @historial }
      else
        format.html { render action: "new" }
        format.json { render json: @historial.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /historials/1
  # PUT /historials/1.json
  def update
    @historial = Historial.find(params[:id])

    respond_to do |format|
      if @historial.update_attributes(params[:historial])
        format.html { redirect_to @historial, notice: 'Historial was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @historial.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /historials/1
  # DELETE /historials/1.json
  def destroy
    @historial = Historial.find(params[:id])
    @historial.destroy

    respond_to do |format|
      format.html { redirect_to historials_url }
      format.json { head :ok }
    end
  end
  def contacto
    @historial = Historial.where(tipolente: true)
    
    respond_to do |format|
      format.html { redirect_to historials_url }
      format.json { head :ok }
    end
  end
end
