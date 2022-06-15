class Media::File < ApplicationRecord
  has_one_attached :file
  
  belongs_to :posts, class_name: 'News::Post', optional: true

  validates :name, presence: true
  validates :file, presence: true

  validates :file, content_type: ['application/vnd.openxmlformats-officedocument.presentationml.presentation', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document','application/vnd.openxmlformats-officedocument.spreadsheetml.sheet','application/pdf','image/gif', 'image/png', 'image/jpeg', 'image/bmp', 'image/webp','image/svg+xml','text/plain','text/html','video/webm','video/mpeg', 'video/ogg','video/mp4','audio/midi', 'audio/mpeg', 'audio/webm', 'audio/ogg', 'audio/wav','audio/mpeg3','audio/x-mpeg-3']
end