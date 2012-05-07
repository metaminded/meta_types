class MetaType < ActiveRecord::Migration
  def up
    execute <<-CREATE_SQL
      create table meta_types (
        id          serial PRIMARY KEY,
        sid         character varying not null UNIQUE,
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
