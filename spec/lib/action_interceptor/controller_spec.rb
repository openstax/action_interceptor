require 'spec_helper'

module ActionInterceptor
  describe Controller do

    it 'modifies ActionController::Base' do
      expect(ActionController::Base).to respond_to(:is_interceptor)
      expect(ActionController::Base).to respond_to(:interceptor_filters)
      expect(ActionController::Base.is_interceptor).to be_false
      expect(ActionController::Base.interceptor_filters).to be_a(Hash)

      expect(ActionController::Base).to respond_to(:interceptor)
      expect(ActionController::Base).to respond_to(:skip_interceptor)
      expect(ActionController::Base).to respond_to(:acts_as_interceptor)

      expect(ActionController::Base.new).to respond_to(:current_page?)
      expect(ActionController::Base.new).to respond_to(:current_url)
      expect(ActionController::Base.new).to respond_to(:current_url_hash)
      expect(ActionController::Base.new).to respond_to(:with_interceptor)
    end

    it 'modifies classes that act_as_interceptor' do
      expect(RegistrationsController.is_interceptor).to be_true

      expect(RegistrationsController.new).to respond_to(:intercepted_url)
      expect(RegistrationsController.new).to respond_to(:intercepted_url=)
      expect(RegistrationsController.new).to respond_to(:intercepted_url_hash)
      expect(RegistrationsController.new).to(
        respond_to(:url_options_without_interceptor))
      expect(RegistrationsController.new).to(
        respond_to(:url_options_with_interceptor))
      expect(RegistrationsController.new).to respond_to(:without_interceptor)
      expect(RegistrationsController.new).to respond_to(:redirect_back)
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
