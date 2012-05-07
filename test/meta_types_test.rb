require 'test_helper'

class MetaTypesTest < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, MetaTypes
  end
end
