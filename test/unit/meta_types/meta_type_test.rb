# encoding: utf-8
#--
# Copyright (c) 2010-2012 Peter Horn, metaminded UG, metaminded.com
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#++

require 'test_helper'

class MetaTypes::MetaTypeTest < ActiveSupport::TestCase

  DATESTRING = '2012-02-22'
  DATE = Date.parse(DATESTRING)

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
      ),
      MetaTypeProperty.new(
        sid:               'bir',
        label:             'Birthday',
        property_type_sid: 'date',
        default_value:     nil
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
      assert thing.properties.bir == nil
      assert thing.properties[:bir].value == nil
      thing = Thing.find(thing.id)
    end
  end

  test "don't use evil names :)" do
    typ = MetaType.new(sid: 'typ', title: 'My Freakin Type')
    mtp = MetaTypeProperty.new(
      sid:               'foo',
      label:             'Foo',
      property_type_sid: 'integer',
      default_value:     '1'
    )
    typ.meta_type_properties << mtp
    assert mtp.valid?
    mtp.sid = 'in'
    assert !mtp.valid?
    mtp.sid = 'map'
    assert !mtp.valid?
    mtp.sid = 'Asassadsd'
    assert !mtp.valid?
  end

  test 'change property values' do
    typ = make()
    assert typ.save

    thing = Thing.new(name: "Har har", meta_type: typ)
    prop = thing.properties
    prop.foo = 2
    prop.bar = "falleri"
    prop.moo = false
    prop.bir = '2012-02-22'
    2.times do
      assert_equal thing.properties.foo,         2
      assert_equal thing.properties[:foo].value, 2
      assert_equal thing.properties.bar,         'falleri'
      assert_equal thing.properties[:bar].value, 'falleri'
      assert_equal thing.properties.moo,         false
      assert_equal thing.properties[:moo].value, false
      assert_equal thing.properties.bir,         DATE
      assert_equal thing.properties[:bir].value, DATE
      thing.save!
      thing = Thing.find(thing.id)
    end
  end

  test 'reordering properties' do
    typ = make()
    assert typ.save

    thing = Thing.new(name: "Har har", meta_type: typ)
    prop = thing.properties_attributes = {
      foo: 2,
      bar: 'falleri',
      moo: false
    }
    thing.properties.bir = DATE
    thing.save!
    thing.reload
    a = thing.properties.map {|mp| mp.value }
    assert_equal [2, "falleri", false, DATE], a

    typ = thing.meta_type
    foo_prop = thing.properties[:foo].meta_type_property
    bar_prop = thing.properties[:bar].meta_type_property
    moo_prop = thing.properties[:moo].meta_type_property
    bir_prop = thing.properties[:bir].meta_type_property
    assert_equal foo_prop.get_position_for(typ), foo_prop.id
    assert_equal bar_prop.get_position_for(typ), bar_prop.id
    assert_equal moo_prop.get_position_for(typ), moo_prop.id
    assert_equal bir_prop.get_position_for(typ), bir_prop.id

    foo_prop.set_position_for!(typ, 9)
    bir_prop.set_position_for!(typ, 7)
    bar_prop.set_position_for!(typ, 5)
    moo_prop.set_position_for!(typ, 2)
    thing = Thing.find(thing.id)
    assert_equal [false, "falleri", DATE, 2], thing.properties.map(&:value)
  end

  test 'mass assign' do
    typ = make()
    assert typ.save

    thing1 = Thing.new(name: "Har har", meta_type: typ, properties_attributes: { foo: 2, bar: 'falleri', moo: false } )
    thing2 = Thing.new(name: "Huhahah", meta_type: typ, properties_attributes: { foo: 4, bar: 'hollera', moo: false } )
    thing3 = Thing.new(name: "hehehee", meta_type: typ, properties_attributes: { foo: 6, bar: 'trullala', moo: true } )
    assert thing1.save && thing2.save && thing3.save
    thing1.reload
    thing2.reload
    thing3.reload
    assert_equal thing1.properties.bar, 'falleri'
    assert_equal thing2.properties.bar, 'hollera'
    assert_equal thing3.properties.bar, 'trullala'
  end

  test 'conditions' do
    typ = make()
    assert typ.save

    thing1 = Thing.new(name: "Har har", meta_type: typ, properties_attributes: { foo: 2, bar: 'falleri', moo: false } )
    thing2 = Thing.new(name: "Huhahah", meta_type: typ, properties_attributes: { foo: 4, bar: 'hollera', moo: false } )
    thing3 = Thing.new(name: "hehehee", meta_type: typ, properties_attributes: { foo: 6, bar: 'trullala', moo: true } )
    assert thing1.save && thing2.save && thing3.save

    assert_equal 0, Thing.where_properties(foo: 1).count
    assert_equal 1, Thing.where_properties(foo: 2).count
    assert_equal 0, Thing.where_properties(foo: 3).count

    assert_equal 0, Thing.where_properties_like(bar: '%ooo%').count
    assert_equal 1, Thing.where_properties_like(bar: '%eri%').count
    assert_equal 2, Thing.where_properties_like(bar: '%lle%').count
    assert_equal 3, Thing.where_properties_like(bar: '%ll%').count
  end

  test 'date stuff' do
    typ = make()
    assert typ.save

    thing = Thing.new(name: "Har har", meta_type: typ, properties_attributes: { bir: DATESTRING } )
    assert_equal DATE, thing.properties.bir
    thing.properties.bir = nil
    thing.update_attributes( properties_attributes: { bir: DATE })
    assert_equal DATE, thing.properties.bir
    thing.update_attributes( properties_attributes: { 'bir(1i)' => '1972', 'bir(2i)' => '2', 'bir(3i)' => 16 })
    assert_equal Date.new(1972, 2, 16), thing.properties.bir
  end
end
