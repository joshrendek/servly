Servly3::Application.routes.draw do


  namespace :admin do 
    root :to => "dashboard#index"
  end

  get "status/elb_check"

  get "user/authorize"

  get "triggered_alerts/index"
  get "triggered_alerts/mark/:mark" => "triggered_alerts#mark", :as => "mark_triggered_alert"
  get "triggered_alerts/new"
  get "triggered_alerts/old"

  get "user_profile/sms"

  get "diagnostic_logs/index"

  get "dashboard/awesome"

  get "diagnostic_logs/show"

  resources :domain_user_group_permissions

  resources :teams        do
    member do
      post 'add_team_user'
      delete 'remove_team_user'
    end
  end

  resources :alerts

  resources :user_profile do
    collection do
      get "sms"
      get "test_sms"
      post "update_sms"
      post "update_profile"
    end
  end

  resources :user_password do
    collection do
      get "edit"
      post "update"
    end
  end

  namespace :sapi do
    get "user/authorize"
    get "user/test"
    post "user/authorize"
    post "server/index"
    get "server/index"
  end

  resources :services do
    resources :servers
  end

  resources :user_management do

    member do
      resources :domain_user_group_permissions, :as => 'permissions' do
        delete '', :as => 'delete_permission', :action => "destroy"
      end
      get 'toggle_activation'
      get 'toggle_alerts'
    end
  end


  get "agent/index"

  get "agent/installer_files"
  get "agent/installer"
  


  resources :network do
    collection do 
      get 'pingmap'
      get 'ping'
      get 'traceroute'
      get 'uptime'
    end
    member do
      get 'do_pingmap'
    end
  end

  resources :servers do

    resources :diagnostic_logs do
      collection do
        get 'run/:command' => "diagnostic_logs#run", :as => 'run'
      end
    end
    resources :server_services  
    collection do 
      get 'healthy'
      get 'dead'
      get 'quick_search'
    end
    member do
      get 'alive'
      get 'uptime(/:downview)', :to => "servers#uptime", :as => 'uptime'
      get 'graphs'
    end
  end

  resources :groups do
    resources :servers do

    resources :diagnostic_logs do
      collection do
        get 'run/:command' => "diagnostic_logs#run", :as => 'run'
      end
    end
    resources :server_services
    collection do
      get 'healthy'
      get 'dead'
      get 'quick_search'
    end
    member do
      get 'alive'
      get 'uptime(/:downview)', :to => "servers#uptime", :as => 'uptime'
      get 'graphs'
    end
  end

    member do
      post 'add_server'
      delete 'remove_server'
    end
  end

  resources :url_monitors

  get "dashboard/index"

  devise_scope :users do
    get "sign_in", :to => "devise/sessions#new"
    put "users/password", :to => "devise/passwords#update", :as => 'password'
    get "users/password", :to => "devise/passwords#edit", :as => 'edit_password'
  end
  devise_for :users

  post 'status/update'
  get 'status/update'
  


  namespace :api do
    post 'terminate'
    resources :servers
    get "user/authorize"
  end

  resources :api do
    collection do
      post 'add_user'
      get 'add_user'
      post 'change_password'
      get 'change_password'
      get 'suspend_domain'
      post 'suspend_domain'
    end
  end
  
  root :to => "dashboard#index"

end
