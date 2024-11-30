class FileUploader < ApplicationUploader
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_allowlist
    %w[jpg jpeg gif png odt doc docx pdf]
  end

  def size_range
    0..(10.megabytes)
  end
end
