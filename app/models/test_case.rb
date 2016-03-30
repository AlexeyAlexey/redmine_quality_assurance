class TestCase < ActiveRecord::Base
  unloadable
  
  acts_as_tree

  belongs_to :issue

  # Yields the given block for each test_case with its level in the tree
  def test_case_tree(test_cases, &block)
    ancestors = []
    test_cases.sort_by(&:lft).each do |test_case|
      while (ancestors.any? && !test_case.is_descendant_of?(ancestors.last))
        ancestors.pop
      end
      yield test_case, ancestors.size
      ancestors << test_case
    end
  end
end
