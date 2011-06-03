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

# HACK
class OpenStruct
  def initialize(hash=nil)
    @table = {}
    if hash
      for k,v in hash
        add_member k, v
      end
    end
  end

  protected
    # if OpenStruct implemented add_member, it would make it easier to extend.
    # see below.
    def add_member k, v
      @table[new_ostruct_member(k)] = v
    end

    # modifiable returns self
    def []= k,v
      add_member k,v
    end

    alias_method :old_modifiable, :modifiable

    def modifiable
      old_modifiable
      self
    end
end

class DeepStruct < OpenStruct
  def self.convert obj
    case obj
    when Hash
      new obj
    when Array
      obj.map{|o| convert o }
    else
      obj
    end
  end

  class << self
    alias_method :[], :convert
  end

  # I would like to see these in OpenStruct as well
  def member? mem
    @table.has_key? mem
  end

  def members
    @table.keys
  end

  protected
    # HACK ostruct should really implement it's own add_member
    def add_member k, v
      v = self.class.convert v
      super
    end
end

class Object
  def to_dstruct
    DeepStruct[ self ]
  end
end
