Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  root 'users#dashboard'

  get 'admin_dashboard', to: 'admins#dashboard'
  get 'teacher_dashboard', to: 'teachers#dashboard'

  resources :student_details


  resources :users, only: [] do
    collection do
      get :home
    end
    member do
      patch :update_role
    end
  end

end
