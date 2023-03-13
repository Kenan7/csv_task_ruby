Rails.application.routes.draw do
  get '', to: 'candidates#index'
  get 'candidates/generate_csv', to: 'candidates#generate_candidates_csv'
end
