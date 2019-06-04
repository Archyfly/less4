module Validation
  NUMBER_FORMAT = /^\w{3}\-?\w{2}$/i.freeze
  TYPE_TRAIN_FORMAT = /(?i)(\W|^)(pass|cargo)(\W|$)/.freeze

  def self.included(base)
    base.extend ClassValids
    base.send :include, InstanceValids
  end

  module ClassValids 
  attr_reader validate_type
    
    def validate(attrib, validate_type)
    choice = validate_type 
    case choice
      when 'presence' then valid_presence(attrib)
      when 'format' then valid_format(attrib, valid_format)
      when 'type' then valid_type(attrib, valid_type)
      end      
    end

  module InstanceValids

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

class Test
  extend Validation

attr_accessor :per1, :per2

  end
