Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #

  resources :home, only:[:index, :dashboard] do
    collection do
      get :dashboard
    end
  end

  resources :tenants do
    resources :hotels
    resources :clients
  end
  resources :users do
    member do
      get :bookings
    end
  end
  resources :booking_requests do
    collection do
      get :outstanding
    end

    member do
      get :book
    end
  end
  resources :bookings do
    collection do
      get :completed
    end
  end

  root 'home#dashboard'
end
