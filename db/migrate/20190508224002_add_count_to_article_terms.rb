class AddCountToArticleTerms < ActiveRecord::Migration[5.2]
  def change
    add_column :article_terms, :count, :integer, default: 0
  end
end
