module ApplicationHelper
  COMMON_YEAR_DAYS_IN_MONTH = [nil, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

  def bootstrap_class_for(flash_type)
    { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type] || flash_type.to_s
  end

  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)} fade in") do
        concat content_tag(:button, "x", class: "close", id: "close_flash", data: { dismiss: "alert" })
        concat message
      end)
    end
    nil
  end

  # def days_in_month(month, year = Time.now.year)
  #   return 29 if month == 2 && Date.gregorian_leap?(year)
  #   COMMON_YEAR_DAYS_IN_MONTH[month]
  # end

  def get_gender_icon(birth)
    case birth.get_gender
    when "Masculino"
      '<h2><i class="fas fa-mars"></i></h2>'.html_safe
    when "Femenino"
      '<h2><i class="fas fa-venus"></i></h2>'.html_safe
    end
  end

  def get_post_status(post)
    case post.status
    when "Borrador"
      '<span class="badge badge-warning">Borrador</span>'.html_safe
    when "Publicado"
      '<span class="badge badge-success">Publicado</span>'.html_safe
    when "Programado"
      '<span class="badge badge-info">Programado</span>'.html_safe
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

  def custom_date(d)
    d.strftime("%d/%m/%Y %H:%M:%S")
  end

  def custom_date_no_hour(d)
    d.strftime("%d/%m/%Y") if d.present?
  end

  # def load_options_multiple(question)
  #   question.options.each do |option|
  #   end
  # end

  # def load_option(question)
  #   case question.question_type
  #   when "Texto"
  #     '<input type="text" class="form-control" name="question.title">'.html_safe
  #   when "Número"
  #     '<input type="number" class="form-control numeric integer required" name="question.title">'.html_safe
  #   when "Verdadero o Falso"
  #     '
  #     <div>
  #       <input type="radio" class="" name="tof" value="true"> Verdadero
  #       <input type="radio" class="" name="tof" value="false"> Falso
  #     </div>'.html_safe
  #   end
  # end

  def user_avatar(user_id)
    user = General::User.find(user_id)
    if user.image.attachment.present?
      image_tag(user.image.attachment.variant(resize: "235x255!").processed, class: "rounded-circle border border-secondary")
    else
      image_tag("default_avatar.png", style: "width:235px;height:255px;")
    end
  end

  def ornanigram_image(user_id)
    user = General::User.find(user_id)
    if user.image.attachment.present?
      image_tag(user.image.attachment.variant(resize: "186x120!").processed, style: "padding: 20px;")
    else
      image_tag("default_avatar.png", style: "width:120;height:186px;padding: 20px;")
    end
  end

  def supported_img(file)
    jpeg = "image/jpeg"
    jpg = "image/jpg"
    png = "image/png"
    if file.attachment.present?
      if file.attachment.content_type == jpeg ||
         file.attachment.content_type == jpg ||
         file.attachment.content_type == png
        return true
      end
    end

    return false
  end

  def supported_video(file)
    mp4 = "video/mp4"
    mov = "video/mov"
    ogg = "video/ogg"
    web = "video/webm"
    if file.attachment.present?
      if file.attachment.content_type == mp4 ||
         file.attachment.content_type == mov ||
         file.attachment.content_type == ogg ||
         file.attachment.content_type == web
        return true
      end
    end

    return false
  end

  def show_media(file)
    if supported_img(file) && file.attachment.attached?
      return image_tag @attachment.attachment.variant(resize: "360x300>")
    elsif supported_video(file) && file.attachment.attached?
      return video_tag(url_for(file.attachment), controls: "", width: "1024px")
    else
      return "<h4>Archivo no soportado</h4>".html_safe
    end
  end

  def show_media_index(file)
    if supported_img(file) && file.attached?
      return image_tag(file.attachment.variant(combine_options: { resize: "x251", gravity: "Center" }), style: "height: 80px; width: 80px; object-fit: cover;")
    elsif supported_video(file) && file.attached?
      return video_tag(url_for(file.attachment), size: "100x100")
    else
      return "<h4>Archivo no soportado</h4>".html_safe
    end
  end

  # def map_attachments
  #   Media::Attachment.all.map { |i| [i.name, i.id, { "data-img-src" => url_for(i.thumb) }] if supported_img(i) && i.present? }
  # end

  # def map_product_images(product_id)
  #   Marketplace::Product.find(product_id).images.map { |i| [i.name, i.id, { "data-img-src" => url_for(i.variant(resize: "120x120>").processed) }] }
  # end

  def map_galleries
    Media::Gallery.all.map { |g| [g.name, g.id, { "data-img-src" => url_for(g.attachments.first.thumb) }] if g.attachments.present? }
  end

  def gender(val)
    val ? "Masculino" : "Femenino"
  end

  def gender_select(val)
    case val
    when nil
      "Elegir sexo"
    when true
      "Masculino"
    when false
      "Femenino"
    end
  end

  def percentage_survey(total_count, total)
    (total_count * 100) / total
  end

  def set_title_menu(parent_id)
    General::Menu.find(parent_id).title if parent_id.present?
  end

  def format_post(data)
    case data
    when data = 0
      return "Estilo Normal"
    when data = 1
      return "Estilo Rosado"
    when data = 2
      return "Estilo Naranja"
    else
      return "Sin Estilo"
    end
  end

  def fullname_user(id)
    user = General::User.find(id)
    return "#{user.name} #{user.last_name}"
  end

  def message_type(type)
    case type
    when type = "birthdays"
      return "Cumpleaños"
    when type = "welcomes"
      return "Bienvenidos"
    when type = "general"
      return "General"
    else
      return "Sin Tipo"
    end
  end

  def result_benefit_for_user(benefit_type)
    case benefit_type
    when benefit_type = "PERMISOS"
      return "5 Días"
    when benefit_type = "BONOS"
      return "$20.000"
    when benefit_type = "SEGUROS"
      return "1 Hora"
    when benefit_type = "CRÉDITOS Y SUBSIDIOS"
      return "1 Hora"
    end
  end

  def currency_is_english?(currency)
    case currency
    when "days"
      "Días"
    when "hours"
      "Horas"
    else
      currency
    end
  end

  def is_target_blank?(value)
    if value == true
      "_blank"
    else
      "_self"
    end
  end

  def fix_content(content)
    content = content.gsub("video controls=\"controls\"", "source")

    get_request_fix_content
    content = content.gsub("<source src=\"../..", "<video src=\"#{get_request_fix_content}")
    content = content.gsub("<source src=\"", "<video src=\"#{get_request_fix_content}/")
    content = content.gsub("<img src=\"../..", "<img src=\"#{get_request_fix_content}")
    content = content.gsub("<img src=\"/rails/", "<img src=\"#{get_request_fix_content}/rails/")
    content = content.gsub("<a href=\"//rails/", "<a href=\"#{get_request_fix_content}/rails/")
    content = content.gsub("<a href=\"/rails/", "<a href=\"#{get_request_fix_content}/rails/")
    content = content.gsub("src=\"/rails/", "src=\"#{get_request_fix_content}/rails/")

    #video
    if content.include?("<p><video style=\"float: right;\"")
      content = content.gsub("<p><video style=\"float: right;\"", '<p align="right"><source style="float: right;"')
    end
    if content.include?("<p><video style=\"float: left;\"")
      content = content.gsub("<p><video style=\"float: left;\"", '<p align="left"><source style="float: left;"')
    end
    if content.include?("<p><video style=\"display: block; margin-left: auto; margin-right: auto;\"")
      content = content.gsub("<p><video style=\"display: block; margin-left: auto; margin-right: auto;\"", '<p align="center"><source style="display: block; margin-left: auto; margin-right: auto;"')
    end
    #image
    if content.include?("<p><img style=\"display: block; margin-left: auto; margin-right: auto;\"")
      content = content.gsub("<p><img style=\"display: block; margin-left: auto; margin-right: auto;\" src=\"/rails/", "<p><img style=\"display: block; margin-left: auto; margin-right: auto;\" src=\"#{get_request_fix_content}/rails/")
    end
    if content.include?("<p><img style=\"float: right;\"")
      content = content.gsub("<p><img style=\"float: right;\" src=\"/rails/", "<p align=\"right\"><img src=\"#{get_request_fix_content}/rails/")
    end

    if content.include?("<p><img style=\"float: left;\"")
      content = content.gsub("<p><img style=\"float: left;\" src=\"/rails/", "<p align=\"left\"><img src=\"#{get_request_fix_content}/rails/")
    end
    if content.include?("<p style=\"text-align: center;\"><img style=\"float: left;\"")
      content = content.gsub("<p style=\"text-align: center;\"><img style=\"float: left;\" src=\"/rails/", "<p style=\"text-align: center;\"><img style=\"float: left;\" src=\"#{get_request_fix_content}/rails/")
    end

    content = content.gsub("<img", '<img style="max-width: 100%; height: auto;"')
    content = content.gsub("<iframe", '<iframe style="max-width: 100%;"')
    content = content.gsub("/></video>", ' width="600" height="350" controls=\"controls\" /></video>')
  end

  def get_frontend_url
    case Rails.env
    when "production"
      "https://mi.security.cl/#"
    when "staging"
      "https://miintranet.exaconsultores.cl/#"
    else
      "http://localhost:8080/#"
    end
  end

  def get_exa_request
    exa_urls = ["https://misecurity-qa3.exa.cl/",
                "https://misecurity-qa2.exa.cl/",
                "https://misecurity-qa.exa.cl/",
                "https://misecurity.exa.cl/"]
  end

  def get_request_referer
    exa_urls = get_exa_request << "https://mi.security.cl/"
    if request.referer.in?(exa_urls)
      "https://mi.security.cl/"
    elsif request.referer == "http://localhost:8080/"
      "http://localhost:8080/"
    elsif request.referer == "https://miintranet.exaconsultores.cl/"
      "https://miintranet.exaconsultores.cl/"
    else
      "https://mi.security.cl/"
    end
  end

  def nav_link(link_text, link_path)
    class_name = current_page?(link_path) ? "active" : ""

    content_tag(:li, :class => class_name) do
      link_to link_text, link_path
    end
  end

  def get_request_fix_content
    if request.referer == "http://localhost:8080/"
      "http://localhost:3000"
    elsif request.referer == "https://miintranet.exaconsultores.cl/"
      "https://intranet.exaconsultores.cl"
    elsif request.referer == "https://mi.security.cl/"
      "https://miapp.security.cl"
    end
  end

  def get_full_favorite_name(user)
    if user.favorite_name.present?
      user.favorite_name + " " + user.last_name
    else
      user.full_name
    end
  end

  def dropdown_active?(modules)
    modules.any? { |w| request.path.include?(w) } ? 'active' : ''
  end

  def get_phone(annexed)
    if annexed.present?
      if annexed[0] == "2" || annexed[0] == "3" || annexed[0] == "4"
        "22584" + annexed
      elsif annexed[0] == "5"
        "22581" + annexed
      elsif annexed[0] == "6"
        "22901" + annexed
      elsif annexed[0] == "7"
        "224618" + annexed[1..annexed.length]
      else
        annexed
      end
    end
  end
end
