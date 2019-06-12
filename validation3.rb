# перепесываем по новой
module Validation

  # метод (класса) validate принимает имя переменной, тип проверки, опциональные аргументы
  def validate(attr_name, validation_type, *arguments)

  end

  # метод (instance) validate! - запускает все проверки в validate - 
  # в случае ошибки выбрасывается исключение какая именно валидация не прошла

  def validate!
  #validate  
 

  end
 
  def presence(attrib) # переименовать в просто presence
    raise "Attribute #{attrib} cannot be nil" if attrib.nil? 
    raise "Attribute #{attrib} cannot be empty" if attrib.empty?
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
