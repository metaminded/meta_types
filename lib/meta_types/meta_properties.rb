class MetaTypes::MetaProperties

  include Enumerable

  attr_accessor :_model
  attr_accessor :_hsname
  attr_accessor :_props

  def initialize(model, hsname)
    self._model = model
    self._hsname = hsname
    self._props = meta_type && meta_type.meta_type_properties.inject({}) do |h, mp|

      h[mp.sid] = MetaTypes::MetaProperty.new(self, mp.sid)

      self.define_singleton_method mp.sid do
        h[mp.sid].value
      end

      self.define_singleton_method "#{mp.sid}=" do |v|
        h[mp.sid].value = v
      end

      h
    end
  end

  def persisted?() false end

  def each()
    _props.each { |k,v| yield(v) }
  end

  def length
    _props.length
  end
  alias_method :count, :length

  def meta_type()
    _model.meta_type
  end

  def set_value(sid, val)
    _model.send "#{_hsname}=", (_model.send("#{_hsname}") || {}).merge(sid => val)
  end

  def get_value(sid)
    _model.send(_hsname).try :[], sid
  end

  def [](sid)
    _props[sid.to_s]
  end
end