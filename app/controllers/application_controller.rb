class ApplicationController < ActionController::API
  # POST "/add_article?title=title&body=hello%20world"
  def add_article
    Article.create(title: params[:title]).index(params[:body])
  end

  # GET "/search_any_term?query=hello+world"
  def search_any_term
    render json: Article.with_any_of_terms(params[:query]).pluck(:title)
  end

  # GET "/search_all_terms?query=hello+world"
  def search_all_terms
    render json: Article.with_all_of_terms(params[:query]).pluck(:title)
  end

  def search_ranked
    # TODO: Return titles of articles that contain ALL of the words from query.
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
    #
    # NOTE: This task is optional.
  end
end
