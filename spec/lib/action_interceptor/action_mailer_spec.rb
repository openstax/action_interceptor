require 'spec_helper'

module ActionInterceptor
  describe ActionMailer do

    it 'modifies ActionMailer::Base' do
      mailer = ::ActionMailer::Base.send(:new)
      expect(mailer.respond_to?(:interceptor_enabled, true)).to eq(true)
      expect(mailer.respond_to?(:interceptor_enabled=, true)).to eq(true)

      expect(mailer.send(:interceptor_enabled)).to eq(false)
      expect(mailer.send(:interceptor_enabled=, true)).to eq(false)
    end

  end
end
