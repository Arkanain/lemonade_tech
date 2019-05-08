class Article < ApplicationRecord
  extend Concerns::TermsSplitter

  has_many :article_terms, dependent: :destroy
  has_many :terms, through: :article_terms

  accepts_nested_attributes_for :article_terms

  scope :filter_by_terms, TermsFilterQuery

  validates :title, presence: true, uniqueness: true

  class << self
    def create_with_terms(attrs)
      create(
        title: attrs[:title],
        article_terms_attributes: parse_terms(attrs[:body])
      )
    end

    private

    def parse_terms(terms_string)
      split_terms(terms_string).map do |term|
        {term: Term.find_or_create_by(value: term)}
      end
    end
  end
end
