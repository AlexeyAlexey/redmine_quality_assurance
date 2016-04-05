class TestCaseProject < ActiveRecord::Base
  unloadable
  
  belongs_to :project 
  belongs_to :test_case
end
