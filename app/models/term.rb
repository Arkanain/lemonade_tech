class Term < ApplicationRecord
  has_many :article_terms, dependent: :destroy
  has_many :articles, through: :article_terms

  validates :value, presence: true, uniqueness: true
end
