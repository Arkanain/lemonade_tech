class TermsFilterQuery
  extend Concerns::TermsSplitter

  class << self
    attr_reader :terms

    def call(terms_string, filter_type = nil)
      @terms = split_terms(terms_string)

      case filter_type
      when :all
        with_all_terms
      when :ranked
        with_ranked_terms
      else
        with_any_terms
      end
    end

    private

    def with_any_terms
      Article.all
        .joins(:terms)
        .where(terms: {value: terms})
        .distinct
    end

    def with_all_terms
      with_any_terms
        .group(:id)
        .having("COUNT(terms.id) = ?", terms.length)
    end

    def with_ranked_terms
      with_all_terms
    end
  end
end
