# enconding: UTF-8

class HistorialsController < ApplicationController

  before_filter :requerir_user
  before_filter :requerir_admin, only: :destroy
  
  proc { |c| c.request.xhr? ? false : 'application'}
  
  # GET /historials
  # GET /historials.json
  def index
    @historials = Historial.order('created_at DESC')
    @contactos = Historial.where(tipolente: true).order('entrega DESC').paginate(page: params[:p_c], per_page: 14)
    @flotante = Historial.where(tipolente: false).order('entrega DESC').paginate(page: params[:p_f], per_page: 14)
    @contactos = Historial.search(params[:s_c]).paginate(page: params[:p_c], per_page: 14) if params[:s_c]
    @flotante = Historial.search(params[:s_f]).paginate(page: params[:p_f], per_page: 14) if params[:s_f]
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @historials }
      format.js
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
        format.html { redirect_to @historial, notice: 'Historial actualizado =)' }
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
  
  def retirar_contacto
    @historial = Historial.find(params[:id])
    @historial.update_attribute :retirado, true
    
    if request.xhr?
      render partial: 'contactos', locals: { historial: @historial }
    else
      respond_to do |format|
        format.html { redirect_to(historials_url) }
        format.json  { head :ok }
        end
    end
  end
  
  def retirar_flotante
    @historial = Historial.find(params[:id])
    @historial.update_attribute :retirado, true
    
    if request.xhr?
      render partial: 'flotantes', locals: { historial: @historial }
    else
      respond_to do |format|
        format.html { redirect_to(historials_url) }
        format.json  { head :ok }
        end
    end
  end
  
  
end
