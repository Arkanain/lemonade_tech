class ArticleTerm < ApplicationRecord
  belongs_to :article
  belongs_to :term
end
