# encoding: utf-8
# (c) 2009-2011 metaminded UG, all rights reserved

<<-CREATE_SQL
  create table meta_type_properties (
    id                serial NOT NULL PRIMARY KEY,
    sid               character varying,
    label             character varying not null,
    property_type_sid character varying not null,
    required          boolean not null default false,
    system            boolean not null default false,
    dimension         character varying null default null,
    default_value     character varying null default null,
    created_at        timestamp without time zone,
    updated_at        timestamp without time zone
  );
CREATE_SQL

class MetaTypeProperty < ActiveRecord::Base

  # Associations
  has_many :meta_type_members
  has_many :meta_types, :through => :meta_type_members

  # Validations
  validates_presence_of :label
  validates_presence_of :property_type_sid
  validates_inclusion_of :property_type_sid, MetaPropertyType.sids

  class << self
    def [](sid) find_by_sid(sid); end
  end


end

