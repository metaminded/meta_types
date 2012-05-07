# encoding: utf-8

# (c) 2012 metaminded UG, all rights reserved

<<-CREATE_SQL
  create table meta_types (
    id          serial PRIMARY KEY,
    sid         character varying not null UNIQUE,
    title       character varying not null UNIQUE,
    created_at  timestamp without time zone,
    updated_at  timestamp without time zone
  );
CREATE_SQL

class MetaType < ActiveRecord::Base

  has_many :meta_type_members
  has_many :meta_type_properties, :through => :meta_type_members, :order => :position

  accepts_nested_attributes_for :meta_type_members
  accepts_nested_attributes_for :meta_type_properties

  validates_presence_of :title
  validates_uniqueness_of :title
  validates_presence_of :sid
  validates_uniqueness_of :sid

  # class methods
  class << self
    def [](sid) find_by_sid(sid); end
  end

  # # add the properties defined by self to the given variant
  # def decorate_variant(v)
  #   v.product_type = self
  #   v.product_properties = product_property_types.map do |pp|
  #     pp.new_property
  #   end
  #   #v.save
  #   v
  # end
  #
  # def add_product_property_type(ppt, position=99999)
  #   PropertyType.transaction do
  #     # attach the new type to self
  #     ptm = ProductTypeMember.new :position => position, :product_type => self, :product_property_type => ppt
  #     ptm.save!
  #     # give all products of 'my' type that property
  #     products.reload
  #     products.each do |prod|
  #       prod.variants.each do |v|
  #         v.product_properties << ppt.new_property
  #         v.save!
  #       end
  #     end
  #   end
  # end
  #
  # def remove_product_property_type(ppt)
  #   ProductPropertyType.find(ppt) unless ppt.is_a?(ProductPropertyType)
  #   ProductType.transaction do
  #     ptm = ProductTypeMember.first :conditions => ["product_type_id=? AND product_property_type_id=?", self.id, ppt.id]
  #     # remove that property from all products of 'my' type
  #     connection.execute "
  #       DELETE FROM product_properties
  #         WHERE product_property_type_id=#{ptm.product_property_type_id}
  #           AND variant_id IN
  #             (SELECT id FROM variants WHERE variants.product_type_id=#{ptm.product_type_id})"
  #     ptm.destroy
  #   end
  # end
end

