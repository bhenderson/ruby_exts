require "minitest/autorun"

require "deep_struct"

class SpecialKeys < DeepStruct
  def new_ostruct_member key
    key = underscore key
    super
  end

  def underscore word
    word = word.to_s.dup
    word.gsub!(/::/, '/')
    word.gsub!(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
    word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
    word.tr!("-", "_")
    word.downcase!
    word
  end
end

class TestOpenStruct < MiniTest::Unit::TestCase
  def test_to_dstruct
    h = {:hi => "mom"}

    assert_equal "mom", h.to_dstruct.hi
  end

  def test_array_to_dstruct
    a = [{:hi => "mom"}]

    assert_equal "mom", a.to_dstruct[0].hi
  end

  def test_nested_dstruct
    h = {:hello => {:world => "hi!"}}

    assert_equal "hi!", h.to_dstruct.hello.world
  end

  def test_keys
    ds = DeepStruct.convert( :hi => "mom" )

    assert_equal [:hi], ds.members
  end

  def test_new_member
    ds = DeepStruct.convert( :hi => "mom" )

    ds.foo = {:hi => "mom"}

    assert_equal "mom", ds.foo.hi
  end

  def test_special_keys
    ds = SpecialKeys.convert( :HiMom => "hello" )

    assert_equal "hello", ds.hi_mom

    ds.foo = {:HiMom => "hello"}

    assert_equal "hello", ds.foo.hi_mom

    ds.Caps = true

    # I think it's unrealistic to expect ds.Caps when we want to explicitely
    # modify other keys passed in any other way
    refute ds.Caps
  end
end
