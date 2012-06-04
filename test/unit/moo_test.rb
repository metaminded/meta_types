require 'test_helper'

class MooTest < ActiveSupport::TestCase
  test "model boots" do
    moo = Moo.create title: 'sdsdsds'
  end

  test "foo" do
    moo = Moo.create title: 'huuuh'

    MetaTypeProperty.create!(
      sid:               'foo_int',
      label:             'FooInteger',
      property_type_sid: 'integer',
      default_value:     '1'
    )
    MetaTypeProperty.create!(
      sid:               'foo_str',
      label:             'FooString',
      property_type_sid: 'string',
      default_value:     'lala'
    )

    moo.notes.foo_str = "troooo"
    moo.notes.foo_int = 23
    moo.save!

    moo2 = Moo.find moo.id

    assert_equal 23, moo2.notes.foo_int
    assert_equal "troooo", moo2.notes.foo_str
  end

end
