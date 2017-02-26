Rails.application.routes.draw do
  root 'home#index'
  get 'jokes/make_allright'
  get 'jokes/overcome_laziness'
  get 'jokes/become_a_cat'
  get 'sidebar/index'
  get 'home/index'
  devise_for :users
end
