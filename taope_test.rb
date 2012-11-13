require "test/unit"
require "taope"

class MyTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  def testTaope
    #puts Taope
    Taope.hello
  end

  def testTaopeOO
   demo = Taope::Demo.new("yy")
   demo.hello
  end
end