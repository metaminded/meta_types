require 'test_helper'

class MetaTypes::MetaTypeTest < ActiveSupport::TestCase

  def make()
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
    typ
  end

  test 'creation and default values' do
    typ = make()
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
  end
  
  test 'change property values' do
    typ = make()
    assert typ.save

    thing = Thing.new(name: "Har har", meta_type: typ)
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
  end
  
  test 'reordering properties' do
    typ = make()
    assert typ.save

    thing = Thing.new(name: "Har har", meta_type: typ)
    prop = thing.properties_values = {
      foo: 2,
      bar: 'falleri',
      moo: false
    }
    thing.save!
    thing.reload
    a = thing.properties.map {|mp| mp.value }
    assert_equal [2, "falleri", false], a
    
    typ = thing.meta_type    
    foo_prop = thing.properties[:foo].meta_type_property
    bar_prop = thing.properties[:bar].meta_type_property
    moo_prop = thing.properties[:moo].meta_type_property
    assert_equal foo_prop.get_position_for(typ), foo_prop.id
    assert_equal bar_prop.get_position_for(typ), bar_prop.id
    assert_equal moo_prop.get_position_for(typ), moo_prop.id
    
    foo_prop.set_position_for!(typ, 9)
    bar_prop.set_position_for!(typ, 5)
    moo_prop.set_position_for!(typ, 2)
    
    thing = Thing.find(thing.id)
    assert_equal [false, "falleri", 2], thing.properties.map(&:value)
  end
end
