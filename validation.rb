module Validation
  #NUMBER_FORMAT = /^\w{3}\-?\w{2}$/i.freeze
  #TYPE_TRAIN_FORMAT = /(?i)(\W|^)(pass|cargo)(\W|$)/.freeze

  def self.included(base)
    base.extend ClassValids
    base.send :include, InstanceValids
  end

  module ClassValids 
  attr_reader :validations
    
    def validate(attrib, validate_type, *args) # Этот метод принимает в качестве параметров имя проверяемого атрибута, а также тип валидации
      @validations ||= {} # задаем хэш :переменная => аттрибуты 
      @validations[attrib] ||= [] 
      @validations[attrib] << { validate_type: validate_type, args: args } # validate :name, :presence, доппараметры
    end
  end

  module InstanceValids

    def validate! #  инстанс-метод validate!, который запускает все проверки (валидации) из validate
      self.class.validations.each do |attrib, validations| 
        attr_name = instance_variable_get("#{attrib}")
        validations.each do |validation|
          send( attr_name, validation[:validate_type], *validation[:args] ) #send(*args) public/ Invokes the method identified by symbol (attr), passing it any arguments specified.
        end
      end
    end

    def valid_presence(attrib)
      raise "Attribute #{attrib} cannot be nil" if attrib.nil? 
      raise "Attribute #{attrib} cannot be empty" if value.strip.empty
    end

    def valid_type(attrib, valid_type)
      raise "Attribute #{attrib} is not #{valid_type}" unless attrib.is_a?(valid_type)
    end

    def valid_format(attrib, valid_format)
      raise "Attribute #{attrib} is not #{valid_format}" if value !~ valid_format
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
end


m = ValidTest.new
m.per1 = 154
m.per2 = '336_ps'
m.per3 = nil

