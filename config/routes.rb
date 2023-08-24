Rails.application.routes.draw do
  get 'products', to: "product#index"
  post 'login', to: "authentication#login"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
