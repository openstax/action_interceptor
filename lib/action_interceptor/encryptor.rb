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

      application = Rails.application
      config = application.config
      application_secret = application.secrets[:secret_key_base] \
                             if application.respond_to?(:secrets)
      application_secret ||= config.secret_key_base \
                               if config.respond_to?(:secret_key_base)
      application_secret ||= config.secret_token

      salt = 'encrypted intercepted url'
      secret = OpenSSL::PKCS5.pbkdf2_hmac_sha1(
                 application_secret, salt, 2**16, 64)

      @message_encryptor = ActiveSupport::MessageEncryptor.new(secret,
        :serializer => ActiveSupport::MessageEncryptor::NullSerializer)
    end

  end
end
