class CreateStudentDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :student_details do |t|
      t.string :name
      t.string :subject
      t.integer :mark

      t.timestamps
    end
  end
end
