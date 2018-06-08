class AttachmentUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    model_id = ('%09d' % model.id).scan(/\d{3}/).join('/')

    "private/attachments/#{model_id}"
  end

  def filename
    if original_filename.present? && super.present?
      "#{super.chomp(File.extname(super))}.png"
    end
  end
end
