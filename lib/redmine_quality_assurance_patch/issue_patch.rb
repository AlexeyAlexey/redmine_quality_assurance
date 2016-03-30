module RedmineQualityAssurancePatch
  module IssuePatch
    def self.included(base) # :nodoc:
  	  base.extend(ClassMethods)
  	  base.send(:include, InstanceMethods)
      # Same as typing in the class
  	  base.class_eval do
    	  unloadable # Send unloadable so it will not be unloaded in development
        has_many :test_cases
  	  end
    end
    
    module ClassMethods
    end

    module InstanceMethods
    end
  end
end
