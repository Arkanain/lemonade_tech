class Term < ApplicationRecord
  has_many :article_terms
  has_many :articles, through: :article_terms
end
