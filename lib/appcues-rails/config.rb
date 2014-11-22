require 'active_support/inflector'

module AppcuesRails

  class ConfigSingleton

    def self.config_accessor(*args, &block)
      config_reader(*args)
      config_writer(*args, &block)
    end

    def self.meta_class
      class << self; self end
    end

    def self.config_reader(name)
      meta_class.send(:define_method, name) do
        instance_variable_get("@#{name}")
      end
    end

    def self.config_writer(name, &block)
      meta_class.send(:define_method, "#{name}=") do |value|
        block.call(value) if block && (block.arity <= 1)

        if block && (block.arity > 1)
          field_name = underscored_class_name ? "#{underscored_class_name}.#{name}" : name
          block.call(value, field_name)
        end

        instance_variable_set("@#{name}", value)
      end
    end

    def self.config_group(name, &block)
      camelized_name = name.to_s.classify
      group = self.const_set(camelized_name, Class.new(self))

      meta_class.send(:define_method, name) do
        group
      end

      group.send(:instance_variable_set, :@underscored_class_name, name)
      group.instance_eval(&block)
    end

    private
    def self.underscored_class_name
      @underscored_class_name
    end

  end

  class Config < ConfigSingleton

    CUSTOM_DATA_VALIDATOR = Proc.new do |custom_data, field_name|
      raise ArgumentError, "#{field_name} custom_data should be a hash" unless custom_data.kind_of?(Hash)
      unless custom_data.values.all? { |value| value.kind_of?(Proc) || value.kind_of?(Symbol) }
        raise ArgumentError, "all custom_data attributes should be either a Proc or a symbol"
      end
    end

    ARRAY_VALIDATOR = Proc.new do |data, field_name|
      raise ArgumentError, "#{field_name} data should be an Array" unless data.kind_of?(Array)
    end

    IS_PROC_VALIDATOR = Proc.new do |value, field_name|
      raise ArgumentError, "#{field_name} is not a proc" unless value.kind_of?(Proc)
    end

    def self.reset!
      to_reset = self.constants.map {|c| const_get c}
      to_reset << self

      to_reset.each do |configer|
        configer.instance_variables.each do |var|
          configer.send(:remove_instance_variable, var)
        end
      end
    end

    config_accessor :appcues_id
    config_accessor :library_url
    config_accessor :enabled_environments, &ARRAY_VALIDATOR

    config_group :user do
      config_accessor :current, &IS_PROC_VALIDATOR
      config_accessor :exclude_if, &IS_PROC_VALIDATOR
      config_accessor :model, &IS_PROC_VALIDATOR
      config_accessor :custom_data, &CUSTOM_DATA_VALIDATOR
    end

  end
end
