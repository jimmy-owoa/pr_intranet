class CreateHelpcenterAnswers < ActiveRecord::Migration[5.2]
  def change
    create_table :helpcenter_satisfaction_answers do |t|
      t.references :user
      t.references :ticket
      t.integer :value

      t.timestamps
    end
  end
end
