ActionDispatch::Callbacks.to_prepare do
  Issue.send :include, RedmineQualityAssurancePatch::IssuePatch
  Project.send :include, RedmineQualityAssurancePatch::ProjectPatch

end

Redmine::Plugin.register :redmine_quality_assurance do
  name 'Redmine Quality Assurance plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'


  project_module :quality_assurance do
    permission :test_cases, { :test_cases => [:index, :show, :new, :create, :edit, :update, :destroy], 
                              :edit_test_cases => [:reload_test_case, :roll_up_test_case] }

    permission :edit_test_cases, { :edit_test_cases => [:view_journal, :edit, :update] }

  end

  settings :default => {'empty' => true}, :partial => 'settings/quality_assurance/settings'

  menu :project_menu, :test_cases, { :controller => 'test_cases', :action => 'index' }, :caption => 'test_cases'
end
