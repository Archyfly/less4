module Validation
  #NUMBER_FORMAT = /^\w{3}\-?\w{2}$/i.freeze
  #TYPE_TRAIN_FORMAT = /(?i)(\W|^)(pass|cargo)(\W|$)/.freeze
  # тут берем из InstanceCounter, принцип тот же
  def self.included(base)
    base.extend ClassValids # для самого метода класса validate
    base.send :include, InstanceValids # тут инстанс-методы validate! valid?
  end

  module ClassValids  # 
  attr_reader :validations # задаем через validate_type
    
    def validate(attrib, validate_type, *args) # Этот метод принимает в качестве параметров имя проверяемого атрибута, а также тип валидации
      @validations ||= {} # задаем хэш :переменная => аттрибуты если еще нету пустой (чтобы получить attrib => [valid_type, args] - по ним геттер)
      @validations[attrib] ||= [] # значение может содержать опциональные аргументы, заполняем при формировании метода
      @validations[attrib] << { validate_type: validate_type, args: args } # пример использования validate :name, :presence, доппараметры
    end
  end

  module InstanceValids #

    def validate! #  инстанс-метод validate!, который запускает все проверки (валидации) из validate
      self.class.validations.each do |attrib, validations| 
        #attr_name = instance_variable_get("#{attrib}")
        attr_name = instance_variable_get("@#{attrib}") # @ иначе не видим
        
        validations.each do |validation| # перебираем массив аргументов validations[attrib] и отправляем методу
          # В СЕНД ИДЕТ СПЕРВА ИМЯ МЕТОДА! которому мы передаем параметры
          send( validation[:validate_type], attr_name, *validation[:args] ) #send(*args) public/ Invokes the method identified by symbol (attr), 
          # passing it any arguments specified.!!!!!!! m.validate :presence, :per1 
        end
      end
    end
    
    # выбираем проверки
    
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

end


class ValidTest
  include Validation

attr_accessor :per1, :per2, :per3
validate :per1, :presence
validate :per2, :type, Integer
validate :per3, :format, /A-Z/
  
end

m = ValidTest.new
# m.per1 = 154
# m.type :per1, Integer 
# m.type :per1, String
# m.format :per1, /A-Z/

