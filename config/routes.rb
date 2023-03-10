Rails.application.routes.draw do
  get 'candidates', to: 'candidates#index'
  get 'candidates/generate_csv', to: 'candidates#generate_csv'
end
