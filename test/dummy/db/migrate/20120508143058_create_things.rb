class CreateThings < ActiveRecord::Migration
  def change
    execute <<-SQL
      create table things(
        id      serial primary key,
        meta_type_id integer references meta_types(id),
        name    character varying,
        properties_hstore hstore,
        created_at timestamp without time zone,
        updated_at timestamp without time zone
      )
    SQL
  end
end
