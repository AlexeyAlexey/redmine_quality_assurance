class CreateTestCaseProjects < ActiveRecord::Migration
  def change
    create_table :test_case_projects do |t|
      t.integer :test_case_id
      t.integer :project_id
      t.timestamps null: false
    end
  end

  def down
    drop_table :test_case_projects
  end
end
