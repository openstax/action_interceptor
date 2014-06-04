require 'spec_helper'

module ActionInterceptor
  describe Mailer do

    it 'modifies ActionMailer::Base' do
      mailer = ActionMailer::Base.send(:new)
      expect(mailer.respond_to?(:use_interceptor, true)).to eq(true)
      expect(mailer.respond_to?(:use_interceptor=, true)).to eq(true)

      expect(mailer.send(:use_interceptor)).to eq(false)
      expect(mailer.send(:use_interceptor=, true)).to eq(false)
    end

  end
end
