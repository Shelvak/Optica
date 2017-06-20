class BillsController < ApplicationController
  before_action :set_bill, only: :show

  # GET /bills
  def index
    @bills = Bill.all
  end

  # GET /bills/1
  def show
  end

  # GET /bills/new
  def new
    @client = Cliente.find(params[:client_id])
    if params[:historial_id]
      @historial = @client.historials.find(params[:historial_id])
      @bill = @historial.build_bill
    else
      @bill = @client.bills.new
    end
  end

  # GET /bills/1/edit
  # def edit
  # end

  # POST /bills
  def create
    @bill = Bill.new(bill_params)

    if @bill.save
      redirect_to @bill, notice: 'Factura creada'
    else
      render :new
    end
  end

  # PATCH/PUT /bills/1
  # def update
  #   if @bill.update(bill_params)
  #     redirect_to @bill, notice: 'Bill was successfully updated.'
  #   else
  #     render :edit
  #   end
  # end

  # DELETE /bills/1
  # def destroy
  #   @bill.destroy
  #   redirect_to bills_url, notice: 'Bill was successfully destroyed.'
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bill
      @bill = Bill.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def bill_params
      params.require(:bill).permit(:client_id, :historial_id, :number, :cae, :sale_point, :billed_date, :cae_due_date, :afip_response, :amount, :vat_amount, :vat, :bill_type, bill_items_attributes: [:description, :amount, :quantity])
    end
end
