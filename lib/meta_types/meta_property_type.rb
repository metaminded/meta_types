class MetaTypes::MetaPropertyType

  attr_accessor :sid
  attr_accessor :name

  def initialize(sid, name)
    self.sid = sid
    self.name = name
  end

  Instances = {
    integer: new('integer', 'Integer'),
    string:  new('string',  'String'),
    boolean: new('boolean', 'Boolean'),
    float:   new('float',   'Float'),
    text:    new('text',    'Text'),
    date:    new('date',    'Date')
  }

  BoolTrueReps = %w{1 t true}

  # cast is called to transform the string-value from the db
  # into the desired ruby type
  def cast(sval)
    case sid
    when 'integer' then sval.to_i
    when 'string', 'text' then sval
    when 'boolean' then BoolTrueReps.member?(sval.to_s)
    when 'float'   then sval.to_f
    when 'date'    then sval && Date.parse(sval)
    else raise "Don't know how to handle MetaPropertyType with sid '#{sid}'."
    end
  end

  # parse is called to transform the given ruby type into the
  # db string format
  def parse(sval)
    case sid
    when 'integer' then sval.to_s
    when 'string', 'text' then sval.to_s
    when 'boolean' then BoolTrueReps.member?(sval.to_s).to_s
    when 'float'   then sval.to_s
    when 'date'    then sval.presence && (sval.is_a?(String) ? Date.parse(sval) : sval).strftime("%Y-%m-%d")
    else raise "Don't know how to handle MetaPropertyType with sid '#{sid}'."
    end
  end

  class << self
    def find(sid)
      Instances[sid.to_sym] || raise("No MetaPropertyType with sid '#{sid}' found.")
    end

    alias_method :[], :find

    def sids() %w{integer string boolean float text date} end
  end

end

