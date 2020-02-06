module Frontend::FrontendHelper
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
    else
      "https://mi.security.cl/"
    end
  end
end
