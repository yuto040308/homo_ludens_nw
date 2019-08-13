require 'rails_helper' # これは書く必要がある
RSpec.describe HomeController, type: :controller do
    describe 'トップページ' do
      context "トップページが正しく表示される" do

        before do
          get :top
        end

        it 'リクエストは200 OKとなること' do
          expect(response.status).to eq 200
        end
      end
    end
end