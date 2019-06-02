module Accessors
  
  def attr_accessor_with_history(*names)
    names.each do |name|
      var_name = "@#{name}".to_sym
      var_name_history = "#{name}_history"

      define_method(name) {instance_variable_get(var_name)}
      
      define_method("#{name}=") do |value|
        instance_variable_set(var_name, value) 
        while !instance_variable_get("@#{var_name_history}") 
        instance_variable_set("@#{var_name_history}", [])  
        end
        instance_variable_get("@#{var_name_history}") << value
     end

     define_method("#{var_name_history}") {instance_variable_get("@#{var_name_history}")}
  end

  def strong_attr_accessor(attr_name, attr_class)
    define_method(attr_name) {instance_variable_get(attr_name)}
    
    define_method("#{attr_name}=") do |value|
        if value.is_a? attr_class
          instance_variable_set("@#{attr_name}", value) 
      else 
        raise ArgumentError.new("Invalid type")
      end
    end   
  end


end


end

class Test
  extend Accessors

  attr_accessor_with_history :c, :d
  self.strong_attr_accessor(:d, Integer)
  
end
