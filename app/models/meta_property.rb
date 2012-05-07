class MetaProperty
  attr_accessor :value
  attr_accessor :meta_type_property
end

class MetaProperties
  attr_accessor :_properties
  def initialize(hstore)
    self._properties = hstore.map do |k,v|
      mp = 
      []
    end
  end
end