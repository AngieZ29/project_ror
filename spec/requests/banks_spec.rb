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
      it 'should return empty data' do
        get '/banks'
        payload = JSON.parse(response.body)
        expect(payload).to be_empty
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'POST /create' do
    context 'when data is ok' do
      req_bank = { bank: { name: Faker::Bank.name } }

      before { post '/banks', params: req_bank }

      it 'should return ok and create record' do
        payload = JSON.parse(response.body)
        expect(payload).not_to be_empty
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when data is not ok' do
      context 'when the name value is nil' do
        req_bank = { bank: { name: nil } }

        before { post '/banks', params: req_bank }

        it 'should return bad_request' do
          payload = JSON.parse(response.body)
          expect(payload).not_to be_empty
          expect(payload['error']).to eq("Couldn't create bank'")
          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'when the name value exceeds 50 characters' do
        req_bank = { bank: { name: 'A' * 51 } }

        before { post '/banks', params: req_bank }

        it 'should return bad_request' do
          payload = JSON.parse(response.body)
          expect(payload).not_to be_empty
          expect(req_bank[:bank][:name].size).not_to eq(50)
          expect(payload['error']).to eq("Couldn't create bank'")
          expect(response).to have_http_status(:bad_request)
        end
      end
    end
  end
end
