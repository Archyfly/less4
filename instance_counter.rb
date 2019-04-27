module InstanceCounter

  def self.included(base)
    base.extend ClassMethod
    base.send :include, InstanceMethod
  end
  
  module ClassMethod
  @instances = 0  
    
    def add_count
      @instances ||= 0
      print @instances += 1
    end  
  end  
  
  module InstanceMethod
  
    def register_instance
      self.class.add_count 
    end
  
  end

end

=begin
class Inst
@instances = 0

include InstanceCounter
  
  def initialize
    @instances += 1
    perem = @instances
    self.class.instances(@perem)
  end

end

inst1 = Inst.new
inst2 = Inst.new
inst3 = Inst.new
=end
