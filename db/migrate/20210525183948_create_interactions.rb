class CreateInteractions < ActiveRecord::Migration[5.2]
  def change
    create_table :news_interactions do |t|
      t.string :interaction_type, default: ""
      t.references :user, null: false
      t.references :post, null: false

      t.timestamps
    end
  end
end
