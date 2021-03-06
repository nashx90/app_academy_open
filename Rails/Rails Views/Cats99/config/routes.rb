Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :cats, only: [:index, :show, :new, :create, :edit, :update]
  resources :cat_foster_requests, only: [:new, :create] do
    member do
      post :approve
      post :deny
    end
  end

  root to: redirect('/cats')
end
