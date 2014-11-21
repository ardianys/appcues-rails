module Appcues
  module Generators
    class ConfigGenerator < ::Rails::Generators::Base

      def self.source_root
        File.dirname(__FILE__)
      end

      argument :appcues_id, :desc => "Your Appcues account ID, which can be found here: https://my.appcues.com/account"

      FALSEY_RESPONSES = ['n', 'no']
      def create_config_file
        @appcues_id = appcues_id

        introduction = <<-desc
Appcues will automatically insert its javascript before the closing '</body>'
tag on every page where it can find a logged-in user. Appcues by default
looks for logged-in users, in the controller, via 'current_user' and '@user'.

Is the logged-in user accessible via either 'current_user' or '@user'? [Yn]
        desc

        print "#{introduction.strip} "
        default_ok = $stdin.gets.strip.downcase

        if FALSEY_RESPONSES.include?(default_ok)
          custom_current_user_question = <<-desc

How do you access the logged-in user in your controllers? This can be
any Ruby code, e.g. 'current_customer', '@admin', etc.:
          desc

          print "#{custom_current_user_question.rstrip} "
          @current_user = $stdin.gets.strip
        end

        template("appcues.rb.erb", "config/initializers/appcues.rb")
      end

    end
  end
end
