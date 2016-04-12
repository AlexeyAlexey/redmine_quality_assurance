# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

resources :test_cases 

resources :edit_test_cases, only: [:view_journal, :edit, :update, :reload_test_case] do 
  collection do 
    get :view_journal
    get :reload_test_case
  end 
end
