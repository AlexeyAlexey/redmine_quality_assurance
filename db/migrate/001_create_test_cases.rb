class CreateTestCases < ActiveRecord::Migration
  def change
    create_table :test_cases do |t|
      t.string  :name
      t.integer :issue_id
      t.integer :parent_id
      t.timestamps null: false
    end

    add_index "test_cases", ["parent_id"], :name => "index_test_cases_on_parent_id"
    add_index "test_cases", ["issue_id"], :name => "index_test_cases_on_issue_id"
  end

  def down
    drop_table :test_cases
  end
end
