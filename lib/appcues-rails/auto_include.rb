module AppcuesRails
  module AutoInclude
    def appcues_rails_auto_include
      AppcuesRails::Processor.process(self)
    end
  end
end
