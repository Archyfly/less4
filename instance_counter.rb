module InstanceCounter
attr_reader :instances

  def self.included(base)
    base.extend ClassMethod
    base.send :include, InstanceMethod
  end
  
  module ClassMethod
  @instances = 0  
    
    def add_count
      @instances ||= 0
      @instances += 1
    end  
  end  
  
  module InstanceMethod
  
    def register_instance
      self.class.add_count 
    end
  
  end
end
