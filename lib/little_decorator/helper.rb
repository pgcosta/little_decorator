class LittleDecorator
  module Helper
    
    def decorate(item_or_collection)
      if item_or_collection.respond_to?(:map)
        item_or_collection.map{ |item| decorate(item) }
      else
        item = item_or_collection
        return item if LittleDecorator === item
        klass = item.class.to_s

        # KlassDecorator exists? if not does SuperKlassDecorator exist? and so on until the superclass is BasicObject
        while klass != "BasicObject"
          decorator_klass = "#{klass}Decorator"
          if class_exists?(decorator_klass)
            decorator = "#{decorator_klass}".constantize
            return decorator.new(item, self)
          else
            klass = "#{klass}".constantize.superclass.to_s
          end
        end
      end
    end

    alias_method :d, :decorate

    def class_exists?(klass)
      Object.const_get(:"#{klass}").is_a?(Class) rescue false
    end

  end
end
