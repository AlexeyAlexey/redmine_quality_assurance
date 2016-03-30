class CreateTestCases < ActiveRecord::Migration
  def change
    create_table :test_cases do |t|
      t.string  :name
      t.integer :issue_id
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
    end

    add_index "test_cases", ["parent_id", "lft", "rgt"], :name => "index_test_cases_on_parent_id_and_lft_and_rgt"
    add_index "test_cases", ["issue_id"], :name => "index_test_cases_on_issue_id"
  end
end
