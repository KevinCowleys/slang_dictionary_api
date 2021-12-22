require 'rails_helper'

describe 'Slangs API', type: :request do
  let!(:first_user) do
    FactoryBot.create(:user, username: 'user1', email: 'user1@fake.com', password: 'Password1', is_admin: true)
  end
  let!(:second_user) do
    FactoryBot.create(:user, username: 'user2', email: 'user2@fake.com', password: 'Password1', is_admin: false)
  end
  let!(:first_slang) do
    FactoryBot.create(:slang, user_id: first_user.id, word: 'Test Word', definition: 'Test Definition',
                              is_approved: false)
  end
  let!(:second_slang) do
    FactoryBot.create(:slang, user_id: second_user.id, word: 'Test Word 2', definition: 'Test Definition 2',
                              is_approved: true)
  end

  describe 'GET /slangs' do
    it 'returns a list of approved slangs' do
      get '/api/v1/slangs'

      expect(response).to have_http_status(:success)
      expect(response_body.size).to eq(1)
      expect(response_body[0]['id']).to eq(second_slang.id)
      expect(response_body[0]['word']).to eq(second_slang.word)
      expect(response_body[0]['definition']).to eq(second_slang.definition)
      expect(response_body[0]['is_approved']).to eq(second_slang.is_approved)
    end
  end

  describe 'POST /slangs' do
    it 'creates new slang' do
      jwt = confirm_and_login_user(first_user)
      expect do
        post '/api/v1/slangs', params: {
          slang: {
            word: 'New Word',
            definition: 'New Definition'
          }
        }, headers: {
          'Authorization' => "Bearer #{jwt}"
        }
      end.to change { Slang.count }.from(2).to(3)

      expect(response).to have_http_status(:created)
    end

    it 'returns error when word is blank' do
      jwt = confirm_and_login_user(first_user)
      expect do
        post '/api/v1/slangs', params: {
          slang: {
            word: '',
            definition: 'New Definition'
          }
        }, headers: {
          'Authorization' => "Bearer #{jwt}"
        }
      end.not_to change { Slang.count }.from(2)

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns error when definition is blank' do
      jwt = confirm_and_login_user(first_user)
      expect do
        post '/api/v1/slangs', params: {
          slang: {
            word: 'New Word',
            definition: ''
          }
        }, headers: {
          'Authorization' => "Bearer #{jwt}"
        }
      end.not_to change { Slang.count }.from(2)

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns error without authentication token' do
      post '/api/v1/slangs'

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
