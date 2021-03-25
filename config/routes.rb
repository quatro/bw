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
      post :cancel_booking, to: 'bookings#cancel'
    end
  end

  resources :customers, only:[:for_client] do
    collection do
      get :for_client
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
      get :report
      get :monthly_sales_data
      get :monthly_license_cost_data
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
      get :client_users
      get :new_staff
      get :new_client_user
      get :autocomplete
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
      get :list_cancelled
      get :list_no_show
    end

    member do
      post :cancel
      post :no_show
      post :resend_email
    end
  end

  root 'home#dashboard'
end
