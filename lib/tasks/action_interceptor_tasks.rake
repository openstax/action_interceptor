namespace :action_interceptor do
  desc 'Copy initializers from action_interceptor to application'
  task :install do
    Dir.glob(File.expand_path('../../../config/initializers/*.rb', __FILE__)) do |file|
      if File.exists?(File.expand_path(File.basename(file), 'config/initializers'))
        print "NOTE: Initializer #{File.basename(file)} from action_interceptor has been skipped. Initializer with the same name already exists.\n"
      else
        cp file, 'config/initializers', :verbose => false
        print "Copied initializer #{File.basename(file)} from action_interceptor.\n"
      end
    end
  end
end

