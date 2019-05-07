class ApplicationController < ActionController::API
  # POST "/add_article?title=title&body=hello%20world"
  def add_article
    Article.create_with_terms(permitted_params)
  end

  # GET "/search_any_term?query=hello+world"
  def search_any_term
    render json: Article.filter_by_terms(params[:query]).pluck(:title)
  end

  # GET "/search_all_terms?query=hello+world"
  def search_all_terms
    render json: Article.filter_by_terms(params[:query], :all).pluck(:title)
  end

  # GET "/search_ranked?query=hello+world"
  def search_ranked
    render json: Article.filter_by_terms(params[:query], :ranked).pluck(:title)
  end

  private

  def permitted_params
    params.permit(:title, :body)
  end
end
