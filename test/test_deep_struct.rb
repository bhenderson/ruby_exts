require "minitest/autorun"

require "deep_struct"

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
end
