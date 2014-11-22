module AppcuesRails
  SCRIPT_TAG_HELPER_CALLED_INSTANCE_VARIABLE = :@_appcues_script_tag_helper_called

  module ScriptTagHelper
    # Generate an appcues script tag.

    def appcues_script_tag(user_details = nil, options={})
      controller.instance_variable_set(AppcuesRails::SCRIPT_TAG_HELPER_CALLED_INSTANCE_VARIABLE, true) if defined?(controller)
      options[:user_details] = user_details if user_details.present?
      options[:find_current_user_details] = !options[:user_details]
      options[:controller] = controller if defined?(controller)

      ScriptTag.generate(options)
    end
  end
end
