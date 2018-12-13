class CreateGeneralTerms < ActiveRecord::Migration[5.2]
  def change
    create_table :general_terms do |t|
      t.references :term_type
      t.text :description
      t.integer :parent_id, index: true
      t.string :name
      t.string :slug
      t.integer :term_order
      t.string :status
      t.integer :count

      t.timestamps
    end
    add_foreign_key :general_terms, :general_term_types, column: :term_type_id
  end
end
