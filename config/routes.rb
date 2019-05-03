Rails.application.routes.draw do
  post '/add_article',      to: 'application#add_article'
  get  '/search_any_term',  to: 'application#search_any_term'
  get  '/search_all_terms', to: 'application#search_all_terms'
end
