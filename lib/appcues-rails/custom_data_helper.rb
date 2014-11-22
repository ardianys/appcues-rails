module AppcuesRails
  module CustomDataHelper
    # This helper allows custom data attributes to be added to a user
    # for the current request from within the controller. e.g.
    #
    # def destroy
    #   appcues_custom_data['canceled_at'] = Time.now
    #   ...
    # end
    def appcues_custom_data
      @_appcues_custom_data ||= {}
    end
  end
end
