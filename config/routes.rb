# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

resources :test_cases

resources :edit_test_cases, only: [:view_journal, :edit, :update] do 
  collection do 
    get :view_journal
  end 
end
