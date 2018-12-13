class CreateGeneralTermRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :general_term_relationships do |t|
      t.string :object_type
      t.integer :object_id
      t.integer :term_order
      t.references :term, foreign_key: {to_table: :general_terms}

      t.timestamps
    end
  end
end
