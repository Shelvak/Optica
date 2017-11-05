class BillsController < ApplicationController
  before_action :requerir_user
  before_action :requerir_admin, only: :destroy
  before_action :set_bill, only: [:show, :invoice, :rollback]
  before_action :load_date_range, only: :index

  # GET /bills
  def index
    @bills = Bill.all
    if params[:bill_number].present?
      @bills = @bills.filtered_list(params[:bill_number])
    else
      @bills = @bills.where(client_id: params[:client_id].to_i) if params[:client_id].present?
      @bills = @bills.where(bill_type: params[:bill_type]) if params[:bill_type]
      @bills = @bills.between(@from_date, @to_date)
    end

    @bills = @bills.order(id: :desc).page(params[:page])
  end

  # GET /bills/1
  def show
  end

  # GET /bills/new
  def new
    @client = Cliente.find(params[:client_id])
    if @client.billing_info_incomplete?
      template = 'bills/incomplete_client'
    else
      template = 'bills/new'
      if params[:historial_id]
        @historial = @client.historials.find(params[:historial_id])
        @bill = @historial.build_bill
      else
        @bill = @client.bills.new
      end
    end

    render template: template
  end

  # POST /bills
  def create
    @bill = Bill.new(bill_params)
    @client = @bill.client

    if @bill.save
      redirect_to @bill, notice: 'Factura creada'
    else
      render :new
    end
  end

  def invoice
    file = WickedPdf.new.pdf_from_string(
      ApplicationController.new.render_to_string(
        (@bill.credit_note ? 'bills/credit_note' : 'bills/invoice'),
        layout: false,
        locals: { bill: @bill, credit_note: @bill.credit_note }
      )
    )

    send_data file, filename: "#{@bill.client.to_s.gsub(' ', '_')}.pdf", type: 'application/pdf'
  end

  def rollback
    @bill.rollback

    if @bill.credit_note.try(:persisted?)
      redirect_to bill_path(@bill.id), notice: 'Nota de crédito creada'
    else
      render :show
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bill
      @bill = Bill.find(params[:id])
      @credit_note = @bill.credit_note
    end

    # Only allow a trusted parameter "white list" through.
    def bill_params
      params.require(:bill).permit(
        :client_id, :historial_id, :number, :cae, :sale_point, :billed_date,
        :cae_due_date, :afip_response, :amount, :vat_amount, :vat, :bill_type,
        :paid_via,
        bill_items_attributes: [:description, :amount, :quantity])
    end

    def load_date_range
      @from_date, @to_date = *make_date_range(params[:interval])
    end
end
