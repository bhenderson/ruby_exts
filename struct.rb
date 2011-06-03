##
# Convert a Hash into a nested Struct.
# the usecase for this might be too specific to be called "convert to struct",
# but I was looking for a way to turn a hash (or a json web api response) into
# an object with accessor methods instead of keys. Struct fit the bill
# perfectly for this already.
#
# require "open-uri"
# require "json"
#
# rails = JSON.parse( open("http://rubygems.org/api/v1/gems/rails.json").read ).to_struct
#
# rails.authors
#  => "David Heinemeier Hansson"
#
# rails.dependencies.runtime[0].name
#  => "actionmailer"
#
# rails.members
#  => [:dependencies, :name, :downloads, :info, ... ]

class Hash
  def to_struct
    # struct members must be symbols
    klass = Struct.new *self.keys.map(&:intern)

    klass.new *self.values.to_struct
  end
end

module Kernel
  def Struct obj
    obj.to_struct
  end
end

class Object
  def to_struct
    self
  end
end

module Enumerable
  def to_struct
    self.map {|o| o.to_struct}
  end
end
