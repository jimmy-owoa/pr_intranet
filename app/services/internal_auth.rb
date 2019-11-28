class InternalAuth
  require "base64"
  require "openssl"

  def initialize
  end

  def self.decrypt(data, cipher_key = nil)
    cipher = OpenSSL::Cipher.new "aes-256-cbc"
    cipher.decrypt
    cipher.key = cipher_key || "EB5932580C920015B65B4B308FF7F352"
    # Proceso de desencriptación
    unescaped = CGI.unescape(data) # Se le quita el urlencode
    decoded = Base64.decode64(unescaped) # Se descodifica de base64
    cipher.iv = decoded[0..15] # Se carga el IV. Este corresponde a los primeros 16 caracteres de la data recibida
    decrypted = cipher.update(decoded[16..decoded.length - 1]) # Se hace el primer paso de desencriptación
    decrypted << cipher.final # Se finaliza la desencriptación
    # Se considera que esté dentro de 1 minuto la solicitud
    timestamp = decrypted[-10..(decrypted.length - 1)].to_i
    if ((timestamp - 30)..(timestamp + 30)).include?(Time.now.utc.to_i)
      # Se retorna el dato del usuariodesencriptado
      return decrypted[0..(decrypted.length - 11)]
    else
      puts "Error de coincidencia de timestamp. Hora local: " + Time.now.utc.to_i.to_s + " - timestamp: " + timestamp.to_s
      raise "Error de coincidencia de timestamp. Hora local: " + Time.now.utc.to_i.to_s + " - timestamp: " + timestamp.to_s
    end
  end

  def self.encrypt(raw_user_cod, cipher_key = nil)
    timestamp = Time.now.utc.to_i
    secret = cipher_key || "EB5932580C920015B65B4B308FF7F352"
    cipher = OpenSSL::Cipher::Cipher.new("aes-256-cbc")

    iv = cipher.random_iv
    cipher.encrypt
    cipher.key = secret

    encrypted_data = cipher.update(raw_user_cod + timestamp.to_s)
    encrypted_data << cipher.final
    data = CGI.escape(Base64.strict_encode64(iv.to_s + encrypted_data))
    return encrypt(raw_user_cod) if "%2B".in?(data)
    data
  end
  # en rails hay que llamar al otro servicio
end

# return CGI.escape(Base64.strict_encode64(iv.to_s) + "&" + Base64.strict_encode64(enctryped_data))
