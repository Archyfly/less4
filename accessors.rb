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

     define_method ("#{var_name_history}") {instance_variable_get("@#{var_name_history}")}
  end

  def strong_attr_accessor 
  
  end
end


end

class Test
  extend Accessors

  attr_accessor_with_history :c, :d
  
  
end
