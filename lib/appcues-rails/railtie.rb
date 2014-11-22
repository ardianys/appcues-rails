module AppcuesRails
  class Railtie < Rails::Railtie
    initializer "appcues-rails" do |app|
      ActionView::Base.send :include, ScriptTagHelper
      ActionController::Base.send :include, CustomDataHelper
      ActionController::Base.send :include, AutoInclude
      ActionController::Base.after_filter :appcues_rails_auto_include
    end
  end
end
