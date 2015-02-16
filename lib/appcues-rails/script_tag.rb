require 'active_support/json'
require 'active_support/core_ext/string/output_safety'

module AppcuesRails
  class ScriptTag
    def self.generate(*args)
      new(*args).output
    end

    attr_reader :user_details
    attr_accessor :controller

    def initialize(options = {})
      self.controller = options[:controller]
      self.user_details = options[:find_current_user_details] ? find_current_user_details : options[:user_details]
    end

    def valid?
      user_details[:appcues_id].present? && user_details[:user_id].present? && user_details[:email].present?
    end

    def output
      user_json = ActiveSupport::JSON.encode(user_details.except(:user_id, :appcues_id)).gsub('<', '\u003C')
      str = <<-APPCUES_SCRIPT
        <link rel="stylesheet" type="text/css" href="//#{AppcuesRails.config.cdn_domain || 'fast.appcues.com'}/appcues.css">
        <script src="//#{AppcuesRails.config.cdn_domain || 'fast.appcues.com'}/#{user_details[:appcues_id]}.js" id="appcues-script"></script>
        <script>
          Appcues.identify('#{user_details[:user_id]}', #{user_json});
        </script>
      APPCUES_SCRIPT

      str.respond_to?(:html_safe) ? str.html_safe : str
    end

    private

    def user_details=(user_details)
      @user_details = DateHelper.convert_dates_to_unix_timestamps(user_details || {})
      @user_details[:appcues_id] ||= AppcuesRails.config.appcues_id
    end

    def find_current_user_details
      return {} unless controller.present?
      Proxy::User.current_in_context(controller).to_hash
    rescue NoUserFoundError
      {}
    end
  end
end

