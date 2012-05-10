class MetaType < ActiveRecord::Migration
  def up
    # we have a type column to allow STI to have a ProductType, a CustomerType and the like
    execute <<-CREATE_SQL
      create table meta_types (
        id          serial PRIMARY KEY,
        sid         character varying not null UNIQUE,
        type        character varying,
        title       character varying not null UNIQUE,
        created_at  timestamp without time zone,
        updated_at  timestamp without time zone
      );
    CREATE_SQL
  end

  def down
    execute "DROP TABLE meta_types"
  end
end
