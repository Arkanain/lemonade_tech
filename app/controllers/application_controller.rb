class ApplicationController < ActionController::API
  # POST "/add_article?title=title&body=hello%20world"
  def add_article
    CreateArticleWithTerms.call(permitted_params)
  end

  # GET "/search_any_term?query=hello+world"
  def search_any_term
    render json: Article.with_any_terms(params[:query]).map(&:title)
  end

  # GET "/search_all_terms?query=hello+world"
  def search_all_terms
    render json: Article.with_all_terms(params[:query]).map(&:title)
  end

  # GET "/search_ranked?query=hello+world"
  def search_ranked
    render json: Article.with_ranked_terms(params[:query]).map(&:title)
  end

  private

  def permitted_params
    params.permit(:title, :body)
  end
end
