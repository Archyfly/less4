# перепесываем по новой
module Validation
attr_accessor :attr_name, :validation_typex

  # метод (класса) validate принимает имя переменной, тип проверки, опциональные аргументы
  def validate(attr_name, validation_type, *arguments)
    # @valids ||= []
    # @valids << [attr_name: attr_name, validation_type: validation_type, arguments: arguments]
    # p "valids = #{@valids}"
  attrib = instance_variable_get("@#{attr_name}")
  # В СЕНД ИДЕТ СПЕРВА ИМЯ МЕТОДА! которому мы передаем параметры
  send(validation_type, attrib, *arguments)       
  end

  # метод (instance) validate! - запускает все проверки в validate - 
  # в случае ошибки выбрасывается исключение какая именно валидация не прошла

  def validate!
    self.valids.each do |attr_name|
      p "attr_name = #{attr_name}"
      attrib = instance_variable_get{"@#{attr_name}"}
      p "attrib= #{attrib}"
      end  
 

  end
 
  def presence(attrib) # переименовать в просто presence
    raise "Attribute #{attrib} cannot be nil" if attrib.nil? 
    
  end

  def type(attrib, valid_type) #??? тоже переим и класс! 
    raise "Attribute #{attrib} is not #{valid_type}" unless attrib.is_a?(valid_type)

  end

  def format(attrib, valid_format) #???? тоже переим и формат
    raise "Attribute #{attrib} is not #{valid_format}" if attrib !~ valid_format
  end

  def valid?
    validate!
  rescue StandardError
    false
  end

end

class Test
include Validation

  attr_accessor :presence_var
  attr_accessor :type_var
  attr_accessor :format_var

end
