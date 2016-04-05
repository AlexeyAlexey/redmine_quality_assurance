class CreateTestCaseProjects < ActiveRecord::Migration
  def change
    create_table :test_case_projects do |t|
      t.integer :test_case_id
      t.integer :project_id
      t.timestamps null: false
    end
    add_index "test_case_projects", ["test_case_id"], :name => "index_test_case_projects_on_test_case_id"
    add_index "test_case_projects", ["project_id"], :name => "index_test_case_projects_on_project_id"
  end

  def down
    drop_table :test_case_projects
  end
end
