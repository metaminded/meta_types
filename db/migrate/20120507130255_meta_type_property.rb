class MetaTypeProperty < ActiveRecord::Migration
  def up
    execute <<-CREATE_SQL
      create table meta_type_properties (
        id                serial NOT NULL PRIMARY KEY,
        sid               character varying,
        label             character varying not null,
        property_type_sid character varying not null,
        required          boolean not null default false,
        system            boolean not null default false,
        dimension         character varying null default null,
        default_value     character varying null default null,
        choices           character varying,
        created_at        timestamp without time zone,
        updated_at        timestamp without time zone
      );
    CREATE_SQL
  end

  def down
    execute "drop table meta_type_properties"
  end
end
