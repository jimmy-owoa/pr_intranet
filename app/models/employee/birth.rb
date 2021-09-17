class Employee::Birth < ApplicationRecord
  include Rails.application.routes.url_helpers

  after_create :default_image
  has_one_attached :photo
  validates :photo, content_type: ['image/png', 'image/jpeg']

  enum permission: %i[No Si]

  belongs_to :user, class_name: "General::User", optional: true

  scope :public_births, -> { where(approved: true, is_public: true) }
  scope :births_between, lambda { |start_date, end_date| where("birthday >= ? AND birthday <= ?", start_date, end_date) }

  PERMISSION = { "todos" => "Todos", true => "Aprobados", false => "No aprobados" }

  def child_fullname
    if self.child_name.present? && self.child_lastname.present? && self.child_lastname2.present?
      return self.child_name.capitalize + " " + self.child_lastname.capitalize + " " + self.child_lastname2.capitalize
    else
      return "Sin nombre"
    end
  end

  def thumb(img)
    img.variant(resize: "60x60>").processed
  end

  def self.approved_filter(data)
    order(id: :desc).where(["approved LIKE ?", data])
  end

  def self.no_approved
    where(approved: false)
  end

  # def default_image
  #   if self.images.first.nil?
  #     self.images.attach(io: File.open("app/assets/images/birth.png"), filename: "birth.png", content_type: "image/png")
  #   end
  # end

  def get_gender
    case self.gender
    when true
      return "Masculino"
    when false
      return "Femenino"
    end
  end

  def get_image
    photo.attached? ? url_for(photo) : ActionController::Base.helpers.asset_path("birth.png")
  end

  def self.get_births_index(page, month)
    births = self.public_births.where('extract(year from birthday) = ?', Date.today.year).where('extract(month from birthday) = ?', month)
    births.order(:birthday).page(page).per(9)
  end

  def unpermitted_image
    photo
  end

  def permitted_image
    if photo.attachment.permission == 1
      return true
    else
      return false
    end
  end

  def default_image
    if !self.photo.attached?
      self.photo.attach(io: File.open("app/assets/images/birth.png"), filename: "birth.png", content_type: "image/png")
    end
  end
end
