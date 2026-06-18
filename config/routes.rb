Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "job_postings#index"
  resources :job_postings, only: [ :index, :show ]
end
