# encoding: UTF-8

class ClientesController < ApplicationController

  before_action :requerir_user
  before_action :requerir_admin, only: :destroy

  # GET /clientes
  # GET /clientes.json
  def index
    @cumples = Cliente.week_birthdays
    @clientes = Cliente.order(
      apellido: :desc, nombre: :desc
    ).filtered_list(params[:s_cliente]).page(params[:page])


    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @clientes }
      format.js
    end
  end

  # GET /clientes/1
  # GET /clientes/1.json
  def show
    @cliente = Cliente.find(params[:id])
    @historiales = @cliente.historials.order(entrega: :desc).page(params[:page])
    @attachments = @cliente.attachments.order(created_at: :desc).page(params[:attach_page])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @cliente }
      format.js
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

    respond_to do |format|
      format.html {
        if @cliente.destroy
          redirect_to clientes_url
        else
          redirect_to cliente_url(@cliente.id), alert: 'No puede borrar un cliente con historial, o facturas'
        end
      }
      format.json { head :ok }
    end
  end


  def autocompletar
    @clientes = Cliente.filtered_list(params[:term]).limit(5)

    respond_to do |format|
      format.json { render json: @clientes.to_json }
    end
  end

  def send_mail
    Emailer::deliver_contact_email(params[:email])
  end
end
