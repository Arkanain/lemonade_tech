Rails.application.routes.draw do
  scope controller: :application do
    post :add_article
    get  :search_any_term
    get  :search_all_terms
    get  :search_ranked
  end
end
