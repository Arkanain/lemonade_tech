class Term < ApplicationRecord
  has_many :article_terms, dependent: :destroy
  has_many :articles, through: :article_terms

  validates_presence_of :value
end
