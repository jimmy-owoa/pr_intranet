module ApplicationHelper

  COMMON_YEAR_DAYS_IN_MONTH = [nil, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

  def bootstrap_class_for flash_type
    { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type] || flash_type.to_s
  end

  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)} fade in") do
        concat content_tag(:button, 'x', class: "close", data: { dismiss: 'alert' })
        concat message
      end)
    end
    nil
  end

  def days_in_month(month, year = Time.now.year)
    return 29 if month == 2 && Date.gregorian_leap?(year)
    COMMON_YEAR_DAYS_IN_MONTH[month]
  end

  def get_gender_icon(birth)
    case birth.get_gender
    when 'Masculino'
      '<h2><i class="fas fa-mars"></i></h2>'.html_safe
    when 'Femenino'
      '<h2><i class="fas fa-venus"></i></h2>'.html_safe
    end
  end

  def get_post_status(post)
    case post.status
    when 'Borrador'
      '<span class="badge badge-warning">Borrador</span>'.html_safe
    when 'Publicado'
      '<span class="badge badge-success">Publicado</span>'.html_safe
    when 'Programado'
      '<span class="badge badge-info">Borrador</span>'.html_safe
    end
  end

  def is_approved(birth)
    case birth.approved
    when true
      '<i class="fas fa-check"></i>'.html_safe
    when false
      '<i class="fas fa-times"></i>'.html_safe
    end
  end

  def custom_date d
    d.strftime("%d/%m/%Y %H:%M:%S")
  end

  def custom_date_no_hour d
    d.strftime("%d/%m/%Y") if d.present?
  end 

  def load_options_multiple question 
    question.options.each do |option|
    end
  end

  def load_option question
    case question.question_type
    when 'Texto'
      '<input type="text" class="form-control" name="question.title">'.html_safe
    when 'Número'
      '<input type="number" class="form-control numeric integer required" name="question.title">'.html_safe
    when 'Verdadero o Falso'
      '
      <div>
        <input type="radio" class="" name="tof" value="true"> Verdadero
        <input type="radio" class="" name="tof" value="false"> Falso 
      </div>'.html_safe
    # when 'Simple'
    #   '<input type="radio" class="form-control" name="question.title">'.html_safe
    # when 'Múltiple'
    #   question.options.each do |a|
    #     '<input type="checkbox" name="#{a.title}" value="#{a.id}" class="">'.html_safe
    #   end
    end
  end
  def user_avatar(user_id)
    user = General::User.find(user_id)
    if user.image.attachment.present?
      image_tag(user.image.attachment.variant(resize: '235x255!').processed, class: 'rounded-circle border border-secondary')
    else
      image_tag("default_avatar.png", style: 'width:235px;height:255px;')
    end
  end

    def ornanigram_image(user_id)
    user = General::User.find(user_id)
    if user.image.attachment.present?
      image_tag(user.image.attachment.variant(resize: '186x120!').processed, style:'padding: 20px;')
    else
      image_tag("default_avatar.png", style: 'width:120;height:186px;padding: 20px;')
    end
  end

  def supported_img file
    jpeg = 'image/jpeg'
    jpg = 'image/jpg'
    png = 'image/png'
    if file.attachment.content_type == jpeg || 
       file.attachment.content_type == jpg || 
       file.attachment.content_type == png
      return true
    end 
  end

  def supported_video file
    mp4 = 'video/mp4'
    mov = 'video/mov'
    # flv = 'video/x-flv'
    # gpp = 'video/3gpp'
    ogg = 'video/ogg'
    web = 'video/webm'
    if file.attachment.content_type == mp4 ||
      #  file.attachment.content_type == flv ||
      #  file.attachment.content_type == gpp || 
       file.attachment.content_type == mov ||
       file.attachment.content_type == ogg ||
       file.attachment.content_type == web
      return true
    end
  end

  def show_media file
    if supported_img(file) && file.attachment.attached?
      return image_tag @attachment.attachment.variant(resize: "360x300>")
    elsif supported_video(file) && file.attachment.attached?
      return video_tag(url_for(file.attachment), controls: '')
    else
      return '<h4>Archivo no soportado</h4>'.html_safe
    end
  end

  def map_attachments 
    General::Attachment.all.map{|i| [i.name, i.id, {'data-img-src'=> url_for(i.thumb)}] if supported_img(i) && i.present?}
  end

  def map_product_images product_id
    Marketplace::Product.find(product_id).images.map{|i| [i.name, i.id, {'data-img-src'=> url_for(i.variant(resize: '120x120>').processed)}]}
  end

  def map_galleries
    General::Gallery.all.map{|g| [g.name, g.id, {'data-img-src'=> url_for(g.attachments.first.thumb)}]if g.attachments.present?}
  end

  def gender(val)
    val ? "Masculino" : "Femenino"
  end

  def gender_select(val)
    case val
    when nil
      'Elegir sexo'
    when true
      'Masculino'
    when false
      'Femenino'            
    end
  end

end
