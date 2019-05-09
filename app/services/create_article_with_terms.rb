class CreateArticleWithTerms
  include Concerns::Service
  include Concerns::TermsSplitter

  def initialize(attrs)
    @attrs = attrs
  end

  def call
    Article.create(
      title: attrs[:title],
      article_terms_attributes: parsed_terms(attrs[:body])
    )
  end

  private

  attr_reader :attrs

  # Terms parsing steps:
  # 
  # "hello hello" =>
  #   ["hello", "hello"] =>
  #     {"hello" => {term: #<Term value: "hello">, count: 2}} =>
  #       [{term: #<Term value: "hello">, count: 2}]
  def parsed_terms(terms_string)
    splitted_terms(terms_string).inject({}) do |hash, term|
      hash.tap do |h|
        if h[term]
          h[term][:count] += 1
        else
          h[term] = {term: Term.find_or_create_by(value: term), count: 1}
        end
      end
    end.values
  end
end
