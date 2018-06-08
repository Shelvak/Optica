class AttachmentsController < ApplicationController

  layout false

  def edit
    @attachment = Attachment.find(params[:id])
  end

  def update
    @attachment = Attachment.find(params[:id])
    title = params[:attachment][:title]
    @attachment.update(title: title) if title
    render body: nil, head: 200
  end

  def destroy
    @attachment = Attachment.find(params[:id])
    @attachment.destroy

    redirect_to :back
  end
end
