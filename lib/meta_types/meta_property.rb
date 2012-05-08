class MetaTypes::MetaProperty
  attr_accessor :meta_properties
  attr_accessor :meta_type_property
  attr_accessor :sid

  def initialize(meta_properties, sid)
    self.meta_properties = meta_properties
    self.sid = sid
    self.meta_type_property = MetaTypeProperty[sid]
  end

  def value
    meta_type_property.cast(meta_properties.try(:get_value, sid) || meta_type_property.default_value)
  end

  def value=(val)
    meta_properties.set_value(sid, meta_type_property.parse(val))
  end

  delegate :sid, :label, :default_value, :unit, :meta_property_type, to: :meta_type_property

end
