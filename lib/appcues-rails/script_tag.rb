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
      user_json = ActiveSupport::JSON.encode(user_details.except(:email, :user_id, :appcues_id)).gsub('<', '\u003C')
      str = <<-APPCUES_SCRIPT
        <link rel="stylesheet" type="text/css" href="//d2dubfq97s02eu.cloudfront.net/appcues.min.css">
        <script src='#{Config.library_url || "//d2dubfq97s02eu.cloudfront.net/appcues.min.js?i=#{user_details[:appcues_id]}"}' data-appcues-id='#{user_details[:appcues_id]}' data-user-id='#{user_details[:user_id]}' data-user-email='#{user_details[:email]}'></script>
        <script>
          Appcues.identify(#{user_json});
          Appcues.init();
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

