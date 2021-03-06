class Article < ApplicationRecord
  extend Concerns::TermsSplitter

  has_many :article_terms, dependent: :destroy
  has_many :terms, through: :article_terms

  accepts_nested_attributes_for :article_terms

  validates :title, presence: true, uniqueness: true

  scope :with_any_terms, ->(terms) do
    joins(article_terms: :term)
      .where(terms: {value: splitted_terms(terms)})
      .distinct
  end

  scope :with_all_terms, ->(terms) do
    with_any_terms(terms)
      .group(:id)
      .having("COUNT(terms.id) = ?", splitted_terms(terms).length)
  end

  scope :with_ranked_terms, ->(terms) do
    with_any_terms(terms)
      .group(:id)
      .select("articles.*, SUM(article_terms.count) as terms_count")
      .order("terms_count DESC")
  end
end
