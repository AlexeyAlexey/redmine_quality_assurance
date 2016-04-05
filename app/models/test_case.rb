class TestCase < ActiveRecord::Base
  unloadable
  
  acts_as_tree

  belongs_to :issue
  has_many :test_case_projects, dependent: :delete_all
  has_many :projects , through: :test_case_projects

  
end
