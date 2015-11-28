# encoding: UTF-8
class VentaController < ApplicationController

  before_filter :requerir_user

  # GET /venta
  # GET /venta.json
  def index
    @venta = Venta.order('anio DESC', 'mes DESC').all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @venta }
    end
  end
end
