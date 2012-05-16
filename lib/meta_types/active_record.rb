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

module MetaTypes::ActiveRecordAddons

  module ClassMethods
    def meta_typed(nam, hstore=nil)
      hstore ||= "#{nam}_hstore"
      raise "No column named '#{hstore}' found." unless attribute_names.member? hstore
      vnam = "@_meta_properties_#{nam}"
      belongs_to :meta_type

      define_method nam do
        return nil unless meta_type
        m = instance_variable_get(vnam)
        m ||= instance_variable_set(vnam, MetaTypes::MetaProperties.new(self, hstore))
      end

      define_method "#{nam}_attributes=" do |hash|
        self.send(nam).update_attributes(hash)
      end
      attr_accessible "#{nam}_attributes"

      self.define_singleton_method "where_#{nam}" do |conditions_hash|
        conditions_hash.inject(where("1=1")) do |relation, (k,v)|
          relation.where("#{hstore} @> (? => ?)", k.to_s, v.to_s)
        end
      end

      self.define_singleton_method "where_#{nam}_like" do |conditions_hash|
        conditions_hash.inject(where("1=1")) do |relation, (k,v)|
          relation.where("#{hstore} -> ? LIKE ?", k.to_s, v.to_s)
        end
      end

      # validate do
      #   v = self.send(nam).valid?
      #   errors.add(nam, v) if v.present?
      # end
    end
  end

  class << self
    def included(by)
      by.send :extend, MetaTypes::ActiveRecordAddons::ClassMethods
    end
  end

end

ActiveRecord::Base.send :include, MetaTypes::ActiveRecordAddons