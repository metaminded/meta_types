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

  attr_accessible :sid, :label, :property_type_sid, :default_value, :required, :dimension

  # Associations
  has_many :meta_type_members
  has_many :meta_types, :through => :meta_type_members

  # Validations
  validates_presence_of :label
  validates_presence_of :property_type_sid
  validates_inclusion_of :property_type_sid, in: MetaTypes::MetaPropertyType.sids

  def property_type
    MetaTypes::MetaPropertyType[property_type_sid]
  end
  
  def set_position_for!(meta_type, pos)
    meta_type_member = meta_type_members.where(meta_type_id: meta_type.id).first
    meta_type_member.position = pos
    meta_type_member.save!
  end

  def get_position_for(meta_type)
    meta_type_member = meta_type_members.where(meta_type_id: meta_type.id).first
    meta_type_member.position
  end

  delegate :cast, :parse, to: :property_type

  class << self
    def [](sid) find_by_sid(sid); end
  end
end

