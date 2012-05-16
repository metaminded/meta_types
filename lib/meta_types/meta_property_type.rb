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

