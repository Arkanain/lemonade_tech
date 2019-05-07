describe ApplicationController do
  describe 'POST /add_article' do
    let(:title) { 'title' }
    let(:body)  { 'hello world' }

    context "with article params" do
      let(:article) { Article.take }

      it "create new article" do
        expect do
          post :add_article, params: { title: title, body: body }
        end.to change(Article, :count).by(1)

        expect(article.title).to eq(title)
        expect(article.terms.pluck(:value)).to contain_exactly("hello", "world")
      end
    end

    context "without article params" do
      it { expect { post :add_article }.not_to change(Article, :count) }
    end

    context "with existed title" do
      before { Article.create_with_terms(title: title, body: body) }

      it "doesn't create article" do
        expect do
          post :add_article, params: { title: title, body: body }
        end.not_to change(Article, :count)
      end
    end
  end

  describe 'GET /search_any_term' do
    let!(:article1) { Article.create_with_terms(title: 'article1', body: 'hello world') }
    let!(:article2) { Article.create_with_terms(title: 'article2', body: 'hello kitty') }

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

  describe "GET /search_all_terms" do
    let!(:article1) { Article.create_with_terms(title: "article1", body: "hello world") }
    let!(:article2) { Article.create_with_terms(title: "article2", body: "hello kitty") }

    subject { JSON.parse(response.body) }

    context "with :query param" do
      before { get :search_all_terms, params: { query: query } }

      context "hello" do
        let(:query) { "hello" }

        it { is_expected.to contain_exactly("article1", "article2") }
      end

      context "hello world" do
        let(:query) { "hello world" }

        it { is_expected.to contain_exactly("article1") }
      end

      context "hello kitty" do
        let(:query) { "hello kitty" }

        it { is_expected.to contain_exactly("article2") }
      end

      context "ruby on rails" do
        let(:query) { "ruby on rails" }

        it { is_expected.to be_empty }
      end
    end

    context "without :query param" do
      before { get :search_all_terms }

      it { is_expected.to be_empty }
    end
  end

  describe "GET /search_ranked" do
    let!(:article1) { Article.create_with_terms(title: "article1", body: "hello hello kitty") }
    let!(:article2) { Article.create_with_terms(title: "article2", body: "hello kitty kitty kitty") }

    subject { JSON.parse(response.body) }

    context "with :query param" do
      before { get :search_ranked, params: { query: query } }

      context "hello" do
        let(:query) { "hello" }

        it { is_expected.to contain_exactly("article1", "article2") }
      end

      context "hello kitty" do
        let(:query) { "hello kitty" }

        it { is_expected.to contain_exactly("article2", "article1") }
      end
    end

    context "without :query param" do
      before { get :search_ranked }

      it { is_expected.to be_empty }
    end
  end
end
