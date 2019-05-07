class Article < ApplicationRecord
  include Concerns::TermsSplitter

  has_many :article_terms, dependent: :destroy
  has_many :terms, through: :article_terms

  scope :filter_by_terms, TermsFilterQuery

  validates_presence_of :title

  class << self
    def create_with_terms(title:, body:)
      new_instance = create(title: title)
      assign_terms(body) if new_instance.valid?
      new_instance
    end
  end

  private

  def assign_terms(terms_string)
    split_terms(terms_string).uniq
  end

  # def save(*args, &block)
  #   body.each { |word| self.terms << Term.find_or_create_by(value: word) } if super
  # end
  #
  # def body=(terms)
  #   @body = split_terms(terms).uniq
  # end
end
