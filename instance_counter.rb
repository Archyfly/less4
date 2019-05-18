module InstanceCounter
  def self.included(base)
    base.extend ClassMethod
    base.send :include, InstanceMethod
  end

  module ClassMethod
    attr_reader :instances

    def add_count
      @instances ||= 0
      @instances += 1
    end
  end

  private

  module InstanceMethod
    def register_instance
      self.class.add_count
    end
  end
end
