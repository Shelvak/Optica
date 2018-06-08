class Attachment < ActiveRecord::Base
  mount_uploader :file, AttachmentUploader

  belongs_to :attachable, polymorphic: true, optional: true

  validates :file, presence: true

  after_initialize :set_attachment_defaults

  private

  def set_attachment_defaults
    self.title ||= self.file.try(:filename)
  end
end
