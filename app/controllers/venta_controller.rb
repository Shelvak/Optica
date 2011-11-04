class VentaController < ApplicationController
  # GET /venta
  # GET /venta.json
  def index
    @venta = Venta.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @venta }
    end
  end

  # GET /venta/1
  # GET /venta/1.json
  def show
    @venta = Venta.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @venta }
    end
  end

  # GET /venta/new
  # GET /venta/new.json
  def new
    @venta = Venta.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @venta }
    end
  end

  # GET /venta/1/edit
  def edit
    @venta = Venta.find(params[:id])
  end

  # POST /venta
  # POST /venta.json
  def create
    @venta = Venta.new(params[:venta])

    respond_to do |format|
      if @venta.save
        format.html { redirect_to @venta, notice: 'Ventum was successfully created.' }
        format.json { render json: @venta, status: :created, location: @venta }
      else
        format.html { render action: "new" }
        format.json { render json: @venta.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /venta/1
  # PUT /venta/1.json
  def update
    @venta = Venta.find(params[:id])

    respond_to do |format|
      if @venta.update_attributes(params[:venta])
        format.html { redirect_to @venta, notice: 'Ventum was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @venta.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /venta/1
  # DELETE /venta/1.json
  def destroy
    @venta = Venta.find(params[:id])
    @venta.destroy

    respond_to do |format|
      format.html { redirect_to venta_url }
      format.json { head :ok }
    end
  end
end
