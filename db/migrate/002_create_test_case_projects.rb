class CreateTestCaseProjects < ActiveRecord::Migration
  def change
    create_table :test_case_projects do |t|
      t.integer :test_case_id
      t.integer :project_id
    end
  end
end
