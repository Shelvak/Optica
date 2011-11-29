class RecetesController < ApplicationController
  
  before_filter :requerir_user
  
  # GET /recetes
  # GET /recetes.json
  def index
    @recetes = Recete.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @recetes }
    end
  end

  # GET /recetes/1
  # GET /recetes/1.json
  def show
    @recete = Recete.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @recete }
    end
  end

  # GET /recetes/new
  # GET /recetes/new.json
  def new
    @recete = Recete.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @recete }
    end
  end

  # GET /recetes/1/edit
  def edit
    @recete = Recete.find(params[:id])
  end

  # POST /recetes
  # POST /recetes.json
  def create
    @recete = Recete.new(params[:recete])
    
    respond_to do |format|
      if @recete.save
        format.html { redirect_to @recete, notice: 'Recete was successfully created.' }
        format.json { render json: @recete, status: :created, location: @recete }
      else
        format.html { render action: "new" }
        format.json { render json: @recete.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /recetes/1
  # PUT /recetes/1.json
  def update
    @recete = Recete.find(params[:id])

    respond_to do |format|
      if @recete.update_attributes(params[:recete])
        format.html { redirect_to @recete, notice: 'Recete was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @recete.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recetes/1
  # DELETE /recetes/1.json
  def destroy
    @recete = Recete.find(params[:id])
    @recete.destroy

    respond_to do |format|
      format.html { redirect_to recetes_url }
      format.json { head :ok }
    end
  end
end
