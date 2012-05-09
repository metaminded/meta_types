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

  attr_accessible :sid, :title, :meta_type_property_ids

  has_many :meta_type_members
  has_many :meta_type_properties, :through => :meta_type_members #, :order => "meta_type_members.position asc"

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

end

