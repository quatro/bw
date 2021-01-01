Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #
  #
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      post :authenticate, to: 'authentication#authenticate'
      # get :booking_requests
      # get :bookings, param: :user_id
      get :user, to: 'users#show'
      post :booking_request, to: 'booking_requests#create'
    end
  end

  resources :home, only:[:index, :dashboard] do
    collection do
      get :dashboard
    end
  end

  resources :tenants do
    member do
      get :hotel
    end
    resources :hotels do
      collection do
        get :map_markers
      end
    end
    resources :clients
  end
  resources :users do
    collection do
      get :staff
      post :create_staff
    end

    member do
      get :bookings
    end
  end
  resources :booking_requests do
    collection do
      get :outstanding
      get :my
    end

    member do
      get :book
      post :claim_and_book
    end
  end
  resources :bookings do
    collection do
      get :completed
    end
  end

  root 'home#dashboard'
end
