class Employee::Birth < ApplicationRecord
  after_create :default_image
  has_one_attached :photo
  enum permission: %i[No Si]

  scope :show_birth , -> {where( approved: true)}
  scope :birt_between, lambda {|start_date, end_date| where("birthday >= ? AND birthday <= ?", start_date, end_date )}


  def child_fullname
    if self.child_name.present? && self.child_lastname.present? 
      return self.child_name + ' ' + self.child_lastname
    else
      return 'Sin nombre'
    end
  end

  def default_image
    if self.photo.attachment.nil?
      self.photo.attach(io: File.open("app/assets/images/birth.png"), filename: "birth.png", content_type: "image/png")
    end
  end

  def get_gender
    case self.gender
    when true
      return 'Masculino'
    when false
      return 'Femenino'
    end
  end
end
