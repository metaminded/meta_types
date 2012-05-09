typ = MetaType.new(sid: 'typ', title: 'My Friggin Type')
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
typ.save!