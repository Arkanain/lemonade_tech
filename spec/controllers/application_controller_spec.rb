describe ApplicationController do
  describe 'POST /add_article' do
    let(:title) { 'title' }
    let(:body)  { 'hello world' }

    context "with article params" do
      before { post :add_article, params: { title: title, body: body } }

      subject(:article) { Article.last }

      specify do
        expect(article.title).to eq(title)
        expect(article.terms.map(&:value)).to match_array(%w[hello world])
      end
    end

    context "without article params" do
      it { expect { post :add_article }.not_to change(Article, :count) }
    end
  end

  describe 'GET /search_any_term' do
    let(:article1) { Article.create(title: 'article1') }
    let(:article2) { Article.create(title: 'article2') }

    before do
      article1.index('hello world')
      article2.index('hello kitty')
    end

    subject { JSON.parse(response.body) }

    context "with :query param" do
      before { get :search_any_term, params: { query: query } }

      context 'hello' do
        let(:query) { 'hello' }

        it { is_expected.to contain_exactly('article1', 'article2') }
      end

      context 'kitty' do
        let(:query) { 'kitty' }

        it { is_expected.to contain_exactly('article2') }
      end

      context 'kitty world' do
        let(:query) { 'kitty world' }

        it { is_expected.to contain_exactly('article1', 'article2') }
      end

      context 'ruby on rails' do
        let(:query) { 'ruby on rails' }

        it { is_expected.to be_empty }
      end
    end

    context "without :query param" do
      before { get :search_any_term }

      it { is_expected.to be_empty }
    end
  end

  describe 'GET /search_all_terms' do

  end

  describe 'GET /search_ranked' do
    # TODO
  end
end
