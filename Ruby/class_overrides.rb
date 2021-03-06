## Class Overrides
## ===============


class Object
  # Search methods of a Ruby Object
  def search_methods(qry)
    self.methods & self.methods.select { |m| m.to_s.include? qry.to_s }
  end

  # Get Local Methods of a Ruby Object
  def local_methods(obj = self)
    (obj.methods - obj.class.superclass.instance_methods).sort
  end

  # Read RI inside IRB
  def ri(method = nil)
    unless method && method =~ /^[A-Z]/ # if class isn't specified
      klass = self.kind_of?(Class) ? name : self.class.name
      method = [klass, method].compact.join('#')
    end
    system 'ri', method.to_s
  end

  alias_method :methods_search, :search_methods
end

module ActiveModel
  module Model
    # Select / put selected fields of a Active/Mongoid Model
    def select_fields(*fields)
      fields.flatten!
      fields.map { |f| self.send f }
    end

    def put_fields(*fields)
      puts select_fields(fields).join(", ")
      nil
    end

    def self.select_fields(*fields)
      self.all.select_fields(*fields)
    end

    def self.put_fields(*fields)
      self.all.put_fields(fields)
    end

    alias_method :put_field,    :put_fields
    alias_method :select_field, :select_fields
  end
end

class Array
  # Quick Display of fields in a List of Documents
  # Prefer `map` for single fields

  def select_fields(*fields)
    self.map do |obj|
      obj.select_fields(fields)
    end
  end

  def put_fields(*fields)
    self.map do |obj|
      obj.put_fields(fields)
    end
    nil
  end

  alias_method :put_field,    :put_fields
  alias_method :select_field, :select_fields
end

class String
  # Colorization
  def colorize(color_code)
      "\e[#{color_code}m#{self}\e[0m"
  end

  def black;          colorize(30);   end
  def red;            colorize(31);   end
  def green;          colorize(32);   end
  def yellow;         colorize(33);   end
  def blue;           colorize(34);   end
  def magenta;        colorize(35);   end
  def cyan;           colorize(36);   end
  def gray;           colorize(37);   end

  def bg_black;       colorize(40);   end
  def bg_red;         colorize(41);   end
  def bg_green;       colorize(42);   end
  def bg_brown;       colorize(43);   end
  def bg_blue;        colorize(44);   end
  def bg_magenta;     colorize(45);   end
  def bg_cyan;        colorize(46);   end
  def bg_gray;        colorize(47);   end

  def bold;           colorize(1);    end
  def reverse_color;  colorize(7);    end
end
