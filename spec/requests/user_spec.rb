require 'rails_helper'

describe 'User API', type: :request do
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

  describe 'GET /user/:user_id' do
    it 'returns user profile with slangs' do
      jwt = confirm_and_login_user(first_user)
      get "/api/v1/user/#{first_user.username}", headers: {
        'Authorization' => "Bearer #{jwt}"
      }

      expect(response).to have_http_status(:success)
    end

    it 'returns error when user doesn\'t exist' do
      get '/api/v1/user/does_not_exist'

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'GET /profile/settings' do
    it 'returns user settings' do
      jwt = confirm_and_login_user(first_user)
      get '/api/v1/profile/settings', headers: {
        'Authorization' => "Bearer #{jwt}"
      }

      expect(response).to have_http_status(:success)
      expect(response_body['id']).to eq(first_user.id)
      expect(response_body['username']).to eq(first_user.username)
      expect(response_body['is_admin']).to eq(first_user.is_admin)
    end

    it 'returns error without authentication token' do
      get '/api/v1/profile/settings'

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'PATCH /profile/settings' do
    it 'patches user settings' do
      jwt = confirm_and_login_user(first_user)
      patch '/api/v1/profile/settings', params: {
        user: {
          username: 'new_username'
        }
      }, headers: {
        'Authorization' => "Bearer #{jwt}"
      }

      expect(response).to have_http_status(:no_content)
    end

    it 'returns error when username is empty' do
      jwt = confirm_and_login_user(first_user)
      patch '/api/v1/profile/settings', params: {
        user: {
          username: ''
        }
      }, headers: {
        'Authorization' => "Bearer #{jwt}"
      }

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns error without authentication token' do
      patch '/api/v1/profile/settings'

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
