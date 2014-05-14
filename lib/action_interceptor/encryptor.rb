module ActionInterceptor
  class Encryptor

    def self.encrypt_and_sign(value)
      message_encryptor.encrypt_and_sign(value)
    end

    def self.decrypt_and_verify(value)
      message_encryptor.decrypt_and_verify(value)
    end

    protected

    def self.message_encryptor
      return @message_encryptor if @message_encryptor
      config = Rails.application.config
      application_secret = config.respond_to?(:secret_key_base) ? \
                             config.secret_key_base : config.secret_token

      # This is how Rails 4 generates keys for encrypted cookies
      # Except that in Rails 4 MessageEncryptor can take 2 different secrets,
      # one for encryption and one for verification
      salt = 'encrypted intercepted url'
      secret = OpenSSL::PKCS5.pbkdf2_hmac_sha1(
                 application_secret, encrypt_salt, 2**16, 64)

      @message_encryptor = ActiveSupport::MessageEncryptor.new(secret,
        :serializer => ActiveSupport::MessageEncryptor::NullSerializer)
    end

  end
end
