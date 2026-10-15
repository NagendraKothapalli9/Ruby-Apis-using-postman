class CreateEmployees < ActiveRecord::Migration[8.1]
  def change
    create_table :employees do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.references :department, null: false, foreign_key: true
      t.string :role

      t.timestamps
    end
  end
end
