module TestCasesHelper
  

  def render_test_case_hierarchy(test_cases, node=nil, options={})
    content = ''
    if test_cases[node]
      content << "<ul class=\"test_cases-hierarchy\">\n"
      test_cases[node].each do |test_case|
        content << "<li>"
        
        content << render(:partial => 'test_cases/test_case', :locals => {:test_case => test_case, :project => @project})
        
        content << "\n" + render_test_case_hierarchy(test_cases, test_case.id, options) if test_cases[test_case.id]
        content << "</li>\n"
      end
      content << "</ul>\n"
    end
    content.html_safe
  end
end
