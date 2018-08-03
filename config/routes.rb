Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/lxd" => "lxds#index"
  get "/lxd/:id" => "lxds#detail"
  root :to => "lxds#index"
end
