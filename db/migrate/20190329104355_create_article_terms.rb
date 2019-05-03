class CreateArticleTerms < ActiveRecord::Migration[5.2]
  def change
    create_table :article_terms do |t|
      t.references :article
      t.references :term
    end
  end
end
