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
  class << self
    def convert obj
      case obj
      when Hash
        keys = obj.keys
        values = obj.values

        DeepStruct.new Hash[ keys.zip( DeepStruct[values] ) ]
      when Array
        obj.map{|o| DeepStruct[ o ]}
      else
        obj
      end
    end

    alias_method :[], :convert
  end

  def members
    @table.keys
  end
end

class Object
  def to_dstruct
    DeepStruct[ self ]
  end
end
