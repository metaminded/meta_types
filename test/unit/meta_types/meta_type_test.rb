require 'test_helper'

class MetaTypes::MetaTypeTest < ActiveSupport::TestCase

  test 'creation' do
    typ = MetaType.new(sid: 'typ', title: 'My Freakin Type')
    typ.meta_type_properties = [
      MetaTypeProperty.new(
        sid:               'foo',
        label:             'Foo',
        property_type_sid: 'integer',
        default_value:     '1'
      ),
      MetaTypeProperty.new(
        sid:               'bar',
        label:             'Bar',
        property_type_sid: 'string',
        default_value:     'lala'
      ),
      MetaTypeProperty.new(
        sid:               'moo',
        label:             'Moo',
        property_type_sid: 'boolean',
        default_value:     'true'
      )
    ]
    assert typ.save

    thing = Thing.new(name: "Har har", meta_type: typ)
    assert thing.save
    2.times do
      assert thing.properties.foo == 1
      assert thing.properties[:foo].value == 1
      assert thing.properties.bar == 'lala'
      assert thing.properties[:bar].value == 'lala'
      assert thing.properties.moo == true
      assert thing.properties[:moo].value == true
      thing = Thing.find(thing.id)
    end

    prop = thing.properties
    prop.foo = 2
    prop.bar = "falleri"
    prop.moo = false
    2.times do
      assert_equal thing.properties.foo,         2
      assert_equal thing.properties[:foo].value, 2
      assert_equal thing.properties.bar,         'falleri'
      assert_equal thing.properties[:bar].value, 'falleri'
      assert_equal thing.properties.moo,         false
      assert_equal thing.properties[:moo].value, false
      thing.save!
      thing = Thing.find(thing.id)
    end
    puts thing.properties.map do |p|
      [p.value, p.label, p.sid, p.default_value]
    end.to_a.to_s

  end
end
