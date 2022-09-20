require 'rails_helper'

RSpec.describe 'Banks', type: :request do
  describe 'GET /index' do
    context 'when exist data' do
      let!(:bank) { create(:bank) }

      it 'should return a bank' do
        get '/banks'
        payload = JSON.parse(response.body)
        expect(payload).not_to be_empty
        expect(payload[0]['id']).to eq(bank.id)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when not exist data' do
      it 'should return nil' do
        get '/banks'
        payload = JSON.parse(response.body)
        expect(payload).to be_empty
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
