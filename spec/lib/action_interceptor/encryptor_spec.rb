require 'spec_helper'

module ActionInterceptor
  describe Encryptor do

    it 'encrypts and decrypts strings' do
      my_string = 'My string'
      encrypted_string = Encryptor.encrypt_and_sign(my_string)
      expect(encrypted_string).not_to include(my_string)

      decrypted_string = Encryptor.decrypt_and_verify(encrypted_string)
      expect(decrypted_string).to eq(my_string)

      expect{Encryptor.decrypt_and_verify(my_string)}.to(
        raise_error(ActiveSupport::MessageVerifier::InvalidSignature))
    end

  end
end
