class GospelService
  require 'uri'
  require 'net/http'

  def initialize
    @api = "http://feed.evangelizo.org/v2/reader.php?"
    @type = "reading"
    @type_title = "reading_lt"
    @lang = "SP"
    @content = "GSP"
  end
  
  def perform
    count = 0
    7.times do 
      date = (Date.today + count.day).strftime("%Y%m%d")
      request_content = URI.parse(@api+"?date="+date+"&type="+@type+"&lang="+@lang+"&content="+@content)
      request_title = URI.parse(@api+"?date="+date+"&type="+@type_title+"&lang="+@lang+"&content="+@content)
      title = Net::HTTP.get_response(request_title).body.force_encoding("UTF-8")
      content = Net::HTTP.get_response(request_content).body.force_encoding("UTF-8")
      Religion::Gospel.where(title: title, content: content, date: date).first_or_create
      count += 1
    end
  end
  
  def self.perform
    new.perform
  end

end