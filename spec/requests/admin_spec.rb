require 'rails_helper'

describe 'Admin API', type: :request do
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

  describe 'GET /admin' do
    it 'returns list of unapproved slang' do
      jwt = confirm_and_login_user(first_user)
      get '/api/v1/admin', headers: {
        'Authorization' => "Bearer #{jwt}"
      }

      expect(response).to have_http_status(:success)
      expect(response_body.size).to eq(1)
      expect(response_body[0]['id']).to eq(first_slang.id)
      expect(response_body[0]['word']).to eq(first_slang.word)
      expect(response_body[0]['definition']).to eq(first_slang.definition)
      expect(response_body[0]['is_approved']).to eq(first_slang.is_approved)
    end

    it 'returns error when requested by non admin' do
      jwt = confirm_and_login_user(second_user)
      get '/api/v1/admin', headers: {
        'Authorization' => "Bearer #{jwt}"
      }

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns error without authentication token' do
      get '/api/v1/admin'

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'PATCH /admin/slang/:slang_id' do
    it 'updates status of slang' do
      jwt = confirm_and_login_user(first_user)
      patch "/api/v1/admin/slang/#{first_slang.id}", headers: {
        'Authorization' => "Bearer #{jwt}"
      }

      expect(response).to have_http_status(:no_content)
    end

    it 'returns error when slang doesn\'t exist' do
      jwt = confirm_and_login_user(first_user)
      patch '/api/v1/admin/slang/1447', headers: {
        'Authorization' => "Bearer #{jwt}"
      }

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns error when not admin' do
      jwt = confirm_and_login_user(second_user)
      patch "/api/v1/admin/slang/#{first_slang.id}", headers: {
        'Authorization' => "Bearer #{jwt}"
      }

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns error without authentication token' do
      patch "/api/v1/admin/slang/#{first_slang.id}"

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'DELETE /admin/slang/:slang_id' do
    it 'deletes the slang' do
      jwt = confirm_and_login_user(first_user)
      delete "/api/v1/admin/slang/#{first_slang.id}", headers: {
        'Authorization' => "Bearer #{jwt}"
      }

      expect(response).to have_http_status(:no_content)
    end

    it 'returns error when slang doesn\'t exist' do
      jwt = confirm_and_login_user(first_user)
      delete '/api/v1/admin/slang/1447', headers: {
        'Authorization' => "Bearer #{jwt}"
      }

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns error when not admin' do
      jwt = confirm_and_login_user(second_user)
      delete "/api/v1/admin/slang/#{first_slang.id}", headers: {
        'Authorization' => "Bearer #{jwt}"
      }

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns error without authentication token' do
      delete "/api/v1/admin/slang/#{first_slang.id}"

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
