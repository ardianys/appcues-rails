require 'appcues-rails/auto_include'
require 'appcues-rails/config'
require 'appcues-rails/custom_data_helper'
require 'appcues-rails/date_helper'
require 'appcues-rails/exceptions'
require 'appcues-rails/processor'
require 'appcues-rails/proxy'
require 'appcues-rails/proxy/user'
require 'appcues-rails/railtie'
require 'appcues-rails/script_tag'
require 'appcues-rails/script_tag_helper'

module AppcuesRails
  def self.config
    block_given? ? yield(Config) : Config
  end
end
