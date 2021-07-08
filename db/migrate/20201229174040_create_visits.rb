class CreateVisits < ActiveRecord::Migration[5.2]
  def change
    create_table :analytic_visits do |t|
      t.string :slug
      t.string :page_type
      t.datetime :visited_at
      t.references :user
    end
  end
end
