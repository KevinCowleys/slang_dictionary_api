require 'rails_helper'

describe 'Vote API', type: :request do
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

  describe 'POST /up_vote/:slang_id' do
    it 'creates an upvote' do
      jwt = confirm_and_login_user(first_user)
      expect do
        post "/api/v1/up_vote/#{second_slang.id}", headers: {
          'Authorization' => "Bearer #{jwt}"
        }
      end.to change { Vote.count }.from(0).to(1)

      expect(response).to have_http_status(:created)
    end

    it 'removes the upvote' do
      FactoryBot.create(:vote, user_id: first_user.id, slang_id: second_slang.id, upvote: true)
      jwt = confirm_and_login_user(first_user)
      expect do
        post "/api/v1/up_vote/#{second_slang.id}", headers: {
          'Authorization' => "Bearer #{jwt}"
        }
      end.to change { Vote.count }.from(1).to(0)

      expect(response).to have_http_status(:no_content)
    end

    it 'creates an upvote if there\'s a downvote' do
      FactoryBot.create(:vote, user_id: first_user.id, slang_id: second_slang.id, upvote: false)
      jwt = confirm_and_login_user(first_user)
      expect do
        post "/api/v1/up_vote/#{second_slang.id}", headers: {
          'Authorization' => "Bearer #{jwt}"
        }
      end.not_to change { Vote.count }.from(1)

      expect(response).to have_http_status(:created)
    end

    it 'returns error when post doesn\'t exist' do
      jwt = confirm_and_login_user(first_user)
      post '/api/v1/up_vote/l447', headers: {
        'Authorization' => "Bearer #{jwt}"
      }

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns error without authentication token' do
      post "/api/v1/up_vote/#{second_slang.id}"

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'POST /down_vote/:slang_id' do
    it 'creates a downvote' do
      jwt = confirm_and_login_user(first_user)
      expect do
        post "/api/v1/down_vote/#{second_slang.id}", headers: {
          'Authorization' => "Bearer #{jwt}"
        }
      end.to change { Vote.count }.from(0).to(1)

      expect(response).to have_http_status(:created)
    end

    it 'removes the downvote' do
      FactoryBot.create(:vote, user_id: first_user.id, slang_id: second_slang.id, upvote: false)
      jwt = confirm_and_login_user(first_user)
      expect do
        post "/api/v1/down_vote/#{second_slang.id}", headers: {
          'Authorization' => "Bearer #{jwt}"
        }
      end.to change { Vote.count }.from(1).to(0)

      expect(response).to have_http_status(:no_content)
    end

    it 'creates a downvote if there\'s an upvote' do
      FactoryBot.create(:vote, user_id: first_user.id, slang_id: second_slang.id, upvote: true)
      jwt = confirm_and_login_user(first_user)
      expect do
        post "/api/v1/down_vote/#{second_slang.id}", headers: {
          'Authorization' => "Bearer #{jwt}"
        }
      end.not_to change { Vote.count }.from(1)

      expect(response).to have_http_status(:created)
    end

    it 'returns error when post doesn\'t exist' do
      jwt = confirm_and_login_user(first_user)
      post '/api/v1/down_vote/1477', headers: {
        'Authorization' => "Bearer #{jwt}"
      }

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns error without authentication token' do
      post "/api/v1/down_vote/#{second_slang.id}"

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
