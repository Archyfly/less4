module Accessors
  # Модуль говорит: когда меня (self) включают (included) в какой-то класс (klass)
  # мне нужно
  # 1. подключить методы из ClassMethods в klass в качестве методов класса
  # 2. подключить методы из InstanceMethods в klass в качастве инстанс-методов
  def self.included(klass)
    klass.extend ClassMethods
  end

  # :nodoc:
  module ClassMethods
    # Этот метод динамически создает геттеры и сеттеры
    # для любого кол-ва атрибутов,
    # при этом сеттер сохраняет все значения инстанс-переменной при изменении этого значения.
    # Пример вызова:
    # attr_accessor_with_history :wagons, :stations, ...
    # # => создает три метода
    #
    # # reader
    # attr_reader :wagons
    #
    # # writer
    # def wagons=(wagons)
    #   @wagons_history << wagons if @wagons_history
    #   @wagons_history ||= []
    #   @wagons = wagons
    # end
    #
    # # history
    # attr_reader :wagon_history
    def attr_accessor_with_history(*attributes)
      # attributes - массив переданных значений
      attributes.each do |attribute|
        class_eval(
          <<-"INSTANCE_DEFINITIONS"
            # reader
            attr_reader :#{attribute}
            # history
            attr_reader :#{attribute}_history
            # writer
            # Нужно сохранять предыдущее значение
            def #{attribute}=(#{attribute})
              # Наверно нам не нужно сохранять первоначальный nil в историю?
              @#{attribute}_history << @#{attribute} if @#{attribute}_history
              @#{attribute}_history ||= []
              @#{attribute} = #{attribute}
            end
          INSTANCE_DEFINITIONS
        )
      end
    end

    def strong_attr_accessor(attribute, klass)
      class_eval(
        <<-"INSTANCE_DEFINITIONS"
          # reader
          attr_reader :#{attribute}
          # writer
          def #{attribute}=(#{attribute})
            raise ArgumentError, "Значение должно быть класса #{klass}" unless #{attribute}.is_a? #{klass}
            @#{attribute} = #{attribute}
          end
        INSTANCE_DEFINITIONS
      )
    end
  end
end
