module TestCasesHelper
  

  def render_test_case_hierarchy(test_cases, node=nil, options={})
    status_colors = Setting.plugin_redmine_quality_assurance["status_colols"] || {} 

    content = ''
    if test_cases[node]
      content << "<ul class=\"test_cases-hierarchy\">\n"
      test_cases[node].each do |test_case|
        content << "<li>"
        
        content << render(:partial => 'test_cases/test_case', :locals => {:test_case => test_case, :project => @project, :status_colors => status_colors})
        
        content << "\n" + render_test_case_hierarchy(test_cases, test_case.id, options) if test_cases[test_case.id]
        content << "</li>\n"
      end
      content << "</ul>\n"
    end
    content.html_safe
  end

  def render_test_case_custom_fields_rows(issue, field_format = ["text"])
    values = issue.visible_custom_field_values.find_all{|c_f_value| field_format.include?(c_f_value.custom_field.field_format)}
    return if values.empty?
    ordered_values = []
    half = (values.size / 2.0).ceil
    half.times do |i|
      ordered_values << values[i]
      ordered_values << values[i + half]
    end
    s = "<tr>\n"
    n = 0
    ordered_values.compact.each do |value|
      css = "cf_#{value.custom_field.id}"
      s << "</tr>\n<tr>\n" if n > 0 && (n % 2) == 0
      s << "\t<th class=\"#{css}\">#{ h(value.custom_field.name) }:</th><td class=\"#{css}\">#{ h(show_value(value)) }</td>\n"
      n += 1
    end
    s << "</tr>\n"
    s.html_safe
  end
end
