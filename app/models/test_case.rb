class TestCase < ActiveRecord::Base
  unloadable
  acts_as_nested_set
  
  belogns_to :issue
end
