require 'rails_helper'

RSpec.describe 'Banks', type: :request do
  describe 'GET /index' do
    context 'when exist data' do
      let!(:bank) { create(:bank) }

      it 'should return a bank' do
        get '/banks'
        payload = response_payload
        expect(payload).not_to be_empty
        expect(payload[0]['id']).to eq(bank.id)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when not exist data' do
      it 'should return empty data' do
        get '/banks'
        payload = response_payload
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
        payload = response_payload
        expect(payload).not_to be_empty
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when data is not ok' do
      context 'when the name value is nil' do
        req_bank = { bank: { name: nil } }

        before { post '/banks', params: req_bank }

        it 'should return bad_request' do
          payload = response_payload
          expect(payload).not_to be_empty
          expect(payload['error']).to eq("Couldn't create bank'")
          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'when the name value exceeds 50 characters' do
        req_bank = { bank: { name: 'A' * 51 } }

        before { post '/banks', params: req_bank }

        it 'should return bad_request' do
          payload = response_payload
          expect(payload).not_to be_empty
          expect(req_bank[:bank][:name].size).not_to eq(50)
          expect(payload['error']).to eq("Couldn't create bank'")
          expect(response).to have_http_status(:bad_request)
        end
      end
    end
  end

  describe 'PUT /update' do
    let!(:bank) { create(:bank) }

    context 'when the name value is updated' do
      req_bank = { bank: { name: 'New Bank' } }

      it 'should return the name field updated' do
        put "/banks/#{bank.id}", params: req_bank

        payload = response_payload
        expect(payload).not_to be_empty
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when not find id of the bank' do
      req_bank = { bank: { name: 'New Bank' } }

      it 'should return not_found' do
        put "/banks/#{'x'}", params: req_bank

        payload = response_payload
        expect(payload['error']).to eq("Couldn't find Bank with 'id'=x")
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when the name value is nil' do
      req_bank = { bank: { name: nil } }

      it 'should return bad_request' do
        put "/banks/#{bank.id}", params: req_bank

        payload = response_payload
        expect(payload['error']).to eq("Couldn't update bank'")
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when the name value exceeds 50 characters' do
      req_bank = { bank: { name: 'A' * 51 } }

      it 'should return bad_request' do
        put "/banks/#{bank.id}", params: req_bank

        payload = response_payload
        expect(payload).not_to be_empty
        expect(payload['error']).to eq("Couldn't update bank'")
        expect(req_bank[:bank][:name].size).not_to eq(50)
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'DELETE / destroy' do
    let!(:bank) { create(:bank) }

    context 'when the bank is deleted' do
      it 'should return the record deleted' do
        delete "/banks/#{bank.id}"

        payload = response_payload
        expect(payload).not_to be_empty
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when not find id of the bank' do
      it 'should return not_found record' do
        delete "/banks/#{2}"

        payload = response_payload
        expect(payload['error']).to eq("Couldn't find Bank with 'id'=2")
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  private

  def response_payload
    JSON.parse(response.body)
  end
end
