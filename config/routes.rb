Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/lxd" => "lxds#index"
  get "/lxd/:id" => "lxds#detail"
  get "/lxc" => "lxcs#index"
  get "/lxc/new" => "lxcs#new"
  post "/lxc/new" => "lxcs#create"
  root :to => "lxds#index"
end
