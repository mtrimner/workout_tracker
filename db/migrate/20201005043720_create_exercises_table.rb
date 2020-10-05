class CreateExercisesTable < ActiveRecord::Migration[5.2]
  def change
    create_table :exercises do |t|
      t.string :exercise_name
      t.string :notes
      t.integer :workout_id
    end
  end
end
