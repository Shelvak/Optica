class FilesController < ApplicationController
  before_action :requerir_user

  def download
    path = params[:path].to_s
    file = ::Rails.root.join('private', path)

    send_file_with_headers(file, non_existent_path: root_path)
  end

  private

  def send_file_with_headers(file, options = {})
    not_file_redirect_to = options[:non_existent_path] || @redirect_path
    not_file_notice = (
      options[:non_existent_notice] || t('view.commons.file_not_found')
    )

    if file.exist? && file.file?
      mime_type = Mime::Type.lookup_by_extension(File.extname(file)[1..-1])

      response.headers['Last-Modified'] = File.mtime(file).httpdate
      response.headers['Cache-Control'] = 'private, no-store'
      response.headers['Content-Length'] = file.size.to_s

      send_file file, type: (mime_type || 'application/octet-stream')
    else
      redirect_to not_file_redirect_to, notice: not_file_notice
    end
  end
end
