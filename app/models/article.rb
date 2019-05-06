class Article < ApplicationRecord
  has_many :article_terms
  has_many :terms, through: :article_terms

  scope :with_any_of_terms, ->(terms) { joins(:terms).where(terms: {value: split_terms(terms)}).distinct }
  scope :with_all_of_terms, ->(terms) {  }

  validates_presence_of :title

  def index(terms)
    tap do |article|
      article.class.split_terms(terms).each do |word|
        self.terms << Term.find_or_create_by(value: word)
      end
    end
  end

  private

  def self.split_terms(terms)
    terms.to_s.split(/\W/)
  end
end
