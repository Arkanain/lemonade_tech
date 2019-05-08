class Article < ApplicationRecord
  include Concerns::TermsSplitter

  has_many :article_terms, dependent: :destroy
  has_many :terms, through: :article_terms

  scope :filter_by_terms, TermsFilterQuery

  validates :title, presence: true, uniqueness: true

  class << self
    def create_with_terms(attrs)
      new_instance = create(title: attrs[:title])
      new_instance.assign_terms(attrs[:body]) if new_instance.valid?
      new_instance
    end
  end

  def assign_terms(terms_string)
    self.terms = split_terms(terms_string).map do |term|
      Term.find_or_create_by(value: term)
    end
  end
end
