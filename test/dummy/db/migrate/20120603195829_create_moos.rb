class CreateMoos < ActiveRecord::Migration
  def change
    execute <<-SQL
      create table moos(
        id         serial primary key,
        title      character varying,
        notess     hstore,
        created_at timestamp without time zone,
        updated_at timestamp without time zone
      )
    SQL
  end
end
