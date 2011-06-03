require "minitest/autorun"

require "struct"

class TestStruct < MiniTest::Unit::TestCase
  def test_hash_to_struct
    h = {:hi => "mom"}

    assert_equal "mom", h.to_struct.hi
  end

  def test_array_to_struct
    a = [{:hi => "mom"}, 3]

    assert_equal "mom", a.to_struct.first.hi
  end

  def test_nested_hash
    h = {:hello => {:world => "hi!"}}

    assert_equal "hi!", h.to_struct.hello.world
  end

  def test_kernel_struct
    obj = Struct( {:hi => "mom" } )

    assert_equal "mom", obj.hi
  end
end
