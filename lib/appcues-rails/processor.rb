module AppcuesRails
  class Processor
    CLOSING_BODY_TAG = %r{</body>}

    def self.process(controller)
      processor = new(controller)
      return unless processor.include_javascript?

      processor.include_javascript!
    end

    attr_reader :controller

    def initialize(kontroller)
      @controller = kontroller
    end

    def include_javascript!
      response.body = response.body.gsub(CLOSING_BODY_TAG, appcues_script_tag.output + '\\0')
    end

    def include_javascript?
      enabled_for_environment? &&
      !appcues_script_tag_called_manually? &&
      html_content_type? &&
      response_has_closing_body_tag? &&
      appcues_script_tag.valid?
    end

    private

    def response
      controller.response
    end

    def html_content_type?
      response.content_type == 'text/html'
    end

    def response_has_closing_body_tag?
      !!(response.body[CLOSING_BODY_TAG])
    end

    def appcues_script_tag_called_manually?
      controller.instance_variable_get(SCRIPT_TAG_HELPER_CALLED_INSTANCE_VARIABLE)
    end

    def appcues_script_tag
      @script_tag ||= ScriptTag.new(:find_current_user_details => true, :controller => controller)
    end

    def enabled_for_environment?
      enabled_environments = AppcuesRails.config.enabled_environments
      return true if enabled_environments.nil?
      enabled_environments.map(&:to_s).include?(Rails.env)
    end
  end
end

