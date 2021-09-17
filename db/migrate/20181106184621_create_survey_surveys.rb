class CreateSurveySurveys < ActiveRecord::Migration[5.2]
  def change
    create_table :survey_surveys do |t|
      t.string :name
      t.string :survey_type
      t.string :status
      t.text :description
      t.date :finish_date
      t.datetime :published_at
      t.boolean :show_name, default: true
      t.boolean :once_by_user, default: true
      t.integer :allowed_answers, default: 0
      t.string :slug, :string, null: true, default: nil
      t.references :profile, null: false
      t.index [ :slug ], unique: true

      t.timestamps
    end
  end
end
