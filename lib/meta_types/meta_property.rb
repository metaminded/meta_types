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

  def choices()
    ch = meta_type_property.choices.presence
    ch && ch.split('||').map(&:strip)
  end

  delegate :sid, :label, :default_value, :dimension, :meta_property_type, :required,
    to: :meta_type_property
end
