TokenAuth::Engine.routes.draw do
  scope '/entities/:entity_id' do
    resource :authentication_token, only: [:update, :destroy]
    resource :configuration_token, only: [:create, :destroy]
    resources :tokens, only: :index
  end

  namespace :api do
    match 'authentication_tokens',
      to: 'authentication_tokens#options',
      via: :options
    resources :authentication_tokens, only: :create
    match 'payloads',
      to: 'payloads#options',
      via: :options
    resources :payloads, only: [:index, :create]
  end
end
