# encoding: UTF-8
class VentaController < ApplicationController

  before_action :requerir_user

  # GET /venta
  # GET /venta.json
  def index
    @venta = Venta.order(year: :desc, month: :desc).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @venta }
    end
  end
end
