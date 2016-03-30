module TestCasesHelper
  # Wrapper for TestCase#project_tree
  def test_case_tree(test_cases, &block)
    TestCase.test_case_tree(test_cases, &block)
  end
end
