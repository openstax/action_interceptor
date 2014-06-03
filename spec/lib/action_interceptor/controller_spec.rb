require 'spec_helper'

module ActionInterceptor
  describe Controller do

    it 'modifies ActionController::Base' do
      expect(ActionController::Base).to respond_to(:is_interceptor)
      expect(ActionController::Base).to respond_to(:use_interceptor)
      expect(ActionController::Base).to respond_to(:interceptor_filters)
      expect(ActionController::Base.is_interceptor).to be_false
      expect(ActionController::Base.interceptor_filters).to be_a(Hash)

      expect(ActionController::Base).to respond_to(:interceptor)
      expect(ActionController::Base).to respond_to(:skip_interceptor)
      expect(ActionController::Base).to respond_to(:acts_as_interceptor)

      expect(ActionController::Base.new.respond_to?(
        :current_page?, true)).to be_true
      expect(ActionController::Base.new.respond_to?(
        :current_url, true)).to be_true
      expect(ActionController::Base.new.respond_to?(
        :current_url_hash, true)).to be_true
      expect(ActionController::Base.new.respond_to?(
        :url_for, true)).to be_true
      expect(ActionController::Base.new.respond_to?(
        :with_interceptor, true)).to be_true
      expect(ActionController::Base.new.respond_to?(
        :without_interceptor, true)).to be_true
    end

    it 'modifies classes that act_as_interceptor' do
      expect(RegistrationsController.is_interceptor).to be_true

      expect(RegistrationsController.new.respond_to?(
        :intercepted_url, true)).to be_true
      expect(RegistrationsController.new.respond_to?(
        :intercepted_url=, true)).to be_true
      expect(RegistrationsController.new.respond_to?(
        :intercepted_url_hash, true)).to be_true
      expect(RegistrationsController.new.respond_to?(
        :redirect_back, true)).to be_true
    end

    it 'registers and skips before_filters' do
      filters = RegistrationsController.new._process_action_callbacks
                                           .collect{|c| c.filter}
      expect(filters).not_to include(:my_interceptor)

      RegistrationsController.interceptor :my_interceptor
      filters = RegistrationsController.new._process_action_callbacks
                                           .collect{|c| c.filter}
      expect(filters).to include(:my_interceptor)

      filters = ApplicationController.new._process_action_callbacks
                                         .collect{|c| c.filter}
      expect(filters).to include(:my_interceptor)

      ApplicationController.skip_interceptor :my_interceptor
      filters = ApplicationController.new._process_action_callbacks
                                         .collect{|c| c.filter}
      expect(filters).not_to include(:my_interceptor)
    end

  end
end