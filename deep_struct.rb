##
# convert hash into a nested OpenStruct
#
# require "open-uri"
# require "json"
#
# rails = JSON.parse( open("http://rubygems.org/api/v1/gems/rails.json").read ).to_dstruct
#
# rails.authors
#  => "David Heinemeier Hansson"
#
# rails.dependencies.runtime.first.name
#  => "actionmailer"

require "ostruct"

class DeepStruct < OpenStruct
  def self.convert obj
    case obj
    when Hash
      keys = obj.keys
      values = obj.values

      new Hash[ keys.zip( convert values ) ]
    when Array
      obj.map{|o| convert o }
    else
      obj
    end
  end

  class << self
    alias_method :[], :convert
  end

  # HACK patch for ostruct
  def initialize(hash=nil)
    @table = {}
    if hash
      for k,v in hash
        add_member k, v
      end
    end
  end

  def member? mem
    @table.has_key? mem
  end

  def members
    @table.keys
  end

  protected
    # HACK ostruct should really implement it's own add_member
    def modifiable
      super
      self
    end

    def add_member key, value
      @table[new_ostruct_member(key)] = self.class[ value ]
    end

    alias_method :[]=, :add_member
end

class Object
  def to_dstruct
    DeepStruct[ self ]
  end
end
