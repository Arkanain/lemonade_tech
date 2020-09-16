class ApplicationController < ActionController::API
  # Add new article with specific title and body.
  #
  # POST "/add_article?title=title&body=hello%20world"
  def add_article
    render json: CreateArticleWithTerms.call(permitted_params)
  end

  # Return titles of articles that contain ANY of the words from query.
  #
  # E.g:
  #
  # Article1 - "hello world"
  # Article2 - "goodbye world"
  #
  # GET "/search_any_term?query=hello" should return only Article1
  # GET "/search_any_term?query=hello+goodbye" should return Article1 and Article2
  def search_any_term
    render json: Article.with_any_terms(params[:query]).map(&:title)
  end

  # Return titles of articles that contain ALL of the words from query.
  #
  # E.g:
  #
  # Article1 - "hello world"
  # Article2 - "hello kitty"
  #
  # GET "/search_all_terms?query=hello+world" should return only Article1
  # GET "/search_all_terms?query=hello" should return Article1 and Article2
  def search_all_terms
    render json: Article.with_all_terms(params[:query]).map(&:title)
  end

  # Return titles of articles that contain ALL of the words from query.
  # Rank the list by total number of occurrences of the search terms in each of the matched articles.
  #
  # E.g:
  #
  # Article1 - "hello hello kitty"
  # Article2 - "hello kitty kitty kitty"
  #
  # GET "/search_ranked?query=hello"
  #
  # Article1 rank = 2 (word "hello" appears twice)
  # Article2 rank = 1 (word "hello" appears once)
  #
  #
  # GET "/search_ranked?query=hello+kitty"
  #
  # Article1 rank = 2 + 1 = 3 (word "hello" appears twice, word "kitty" appears once)
  # Article2 rank = 1 + 3 = 4 (word "hello" appears once, word "kitty" appears 3 times)
  def search_ranked
    render json: Article.with_ranked_terms(params[:query]).map(&:title)
  end

  private

  def permitted_params
    params.permit(:title, :body)
  end
end
