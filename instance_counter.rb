module InstanceCounter

  def self.included(base)
    base.extend ClassMethod
    base.send :include, InstanceMethod
  end

  module ClassMethod
    @@instances = 0
    def instances_1
    puts "Class Method included!"  
    puts "@@instances = #{@@instances}"  
    end
  end
  
  module InstanceMethod
    @@register_instance = 0
    @register_instance_count = 0
    def register_instance_1
      puts "register_instance = #{@register_instance_count+register_instance}"  
      puts "Register Method included ! register_instance = #{@register_instance_count}"  
    end
    
    def regin_up
      @@register_instance += 1
    end  
  end
  
  private

  attr_accessor :register_instance

end


class Inst
@@instances = 50
@@register_instance = 100
  
include InstanceCounter
include InstanceMethod

  def print_inst
    puts "!@@instances = #{@@instances}"  
    puts "!register_instance = #{register_instance_1}"  
    #self.class.register_instance += 1       
  self.class.regin_up 
  end
end
inst1 = Inst.new

Inst.instances_1

inst1.regin_up
inst1.register_instance_1
inst2 = Inst.new
inst1.register_instance_1
inst3 = Inst.new
inst1.register_instance_1
inst4 = Inst.new
inst1.register_instance_1
inst5 = Inst.new
inst1.register_instance_1
