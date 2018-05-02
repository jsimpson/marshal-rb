require 'marshal-rb/version'

module MarshalRb
  extend self

  MAJOR_VERSION = 4
  MINOR_VERSION = 8

  autoload :ReadBuffer,  'marshal-rb/read_buffer'
  autoload :WriteBuffer, 'marshal-rb/read_buffer'

  def dump(object)
    WriteBuffer.new(object).write
  end

  def load(object)
    ReadBuffer.new(object).read
  end
end
