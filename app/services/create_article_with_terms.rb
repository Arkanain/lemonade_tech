class CreateArticleWithTerms
  include Concerns::TermsSplitter

  def initialize(attrs)
    Article.create(
      title: attrs[:title],
      article_terms_attributes: parse_terms(attrs[:body])
    )
  end

  private

  def parse_terms(terms_string)
    splitted_terms(terms_string).map do |term|
      {
        term: Term.find_or_create_by(value: term)
      }
    end
  end
end
