module MarshalRb
  class ReadBuffer
    attr_reader :data

    def initialize(data)
      @data = data.chars
      @major_version = read_byte
      @minor_version = read_byte
    end

    get_sequence = lambda do |n|
      buffer = ReadBuffer.new(Marshal.dump(n))
      buffer.read_char
      buffer.data.map(&:ord)
    end

    def read
      char = read_char
      case char
      when '0' then nil
      when 'T' then true
      when 'F' then false
      when 'i' then read_integer
      when ':' then read_symbol
      when '"' then read_string
      when '[' then read_array
      when '{' then read_hash
      when 'f' then read_float
      when 'c' then read_class
      else
        raise NotImplementedError, "Unknown object type #{char}."
      end
    end

    def read_array
      read_integer.times.map { read }
    end

    def read_byte
      read_char.ord
    end

    def read_char
      @data.shift
    end

    def marshal_const_get(name)
      Object.get_const(name)
    rescue NameError
      raise ArgumentError, "undefined class/module #{const_name}"
    end

    def read_class
      const_name = read_string
      klass = marshal_const_get(const_name)
      unless klass.instance_of?(Class)
        raise ArgumentError, "#{const_name} does not refer to a Class"
      end
      klass
    end

    def read_float
      read_string.to_f
    end

    def read_hash
      pairs = read_integer.times.map { [read, read] }
      Hash[pairs]
    end

    def read_integer
      c = (read_byte ^ 128) - 128

      case c
      when 0
        0
      when (4..127)
        c - 5
      when (1..3)
        c
          .times
          .map { |i| [i, read_byte] }
          .inject(0) { |result, (i, byte)| result | (byte << (8 * i)) }
      when (-128..-6)
        c + 5
      when (-5..-1)
        (-c)
          .times
          .map { |i| [i, read_byte] }
          .inject(-1) do |result, (i, byte)|
          a = ~(0xff << (8 * i))
          b = byte << (8 * i)
          (result & a) | b
        end
      end
    end

    def read_string
      read_integer.times.map { read_char }.join
    end

    def read_symbol
      read_integer.times.map { read_char }.join.to_sym
    end
  end
end
