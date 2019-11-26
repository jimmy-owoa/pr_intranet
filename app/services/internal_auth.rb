class InternalAuth
  require "base64"
  require "openssl"

  def initialize
  end

  def self.decrypt(data, cipher_key = nil)
    cipher = OpenSSL::Cipher.new "aes-256-cbc"
    cipher.decrypt
    cipher.key = cipher_key || "EB5932580C920015B65B4B308FF7F352"
    unescaped = CGI.unescape(data) # Se le quita el urlencode
    # se encuentran los datos el IV y del dato encriptado separados por &
    base64_data = unescaped.split("&")
    # Se descodifica de base64 cada dato
    decoded_iv = Base64.decode64(base64_data[0])
    decoded_encrypt = Base64.decode64(base64_data[1])
    cipher.iv = decoded_iv # Se carga el IV
    decrypted = cipher.update(decoded_encrypt) # Se hace el primer paso de desencriptación
    decrypted << cipher.final # Se finaliza la desencriptación
    timestamp = decrypted[-10..(decrypted.length - 1)].to_i
    return decrypted[0..(decrypted.length - 11)]
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
    return CGI.escape(Base64.strict_encode64(iv.to_s) + "&" + Base64.strict_encode64(encrypted_data)) # Se retorna agregando '&' para separar iv con la data en el decrypt
  end
  # en rails hay que llamar al otro servicio
end

# return CGI.escape(Base64.strict_encode64(iv.to_s) + "&" + Base64.strict_encode64(enctryped_data))
