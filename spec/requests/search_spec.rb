require 'rails_helper'

describe 'Search API', type: :request do
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
  let!(:third_slang) do
    FactoryBot.create(:slang, user_id: first_user.id, word: 'New Word 1', definition: 'Test Definition 3',
                              is_approved: true)
  end

  describe 'GET /slangs' do
    it 'returns a list slangs when empty' do
      get '/api/v1/search?q='

      expect(response).to have_http_status(:success)
      expect(response_body.size).to eq(2)
      expect(response_body[0]['id']).to eq(second_slang.id)
      expect(response_body[0]['word']).to eq(second_slang.word)
      expect(response_body[0]['definition']).to eq(second_slang.definition)
      expect(response_body[0]['is_approved']).to eq(second_slang.is_approved)
      expect(response_body[1]['id']).to eq(third_slang.id)
      expect(response_body[1]['word']).to eq(third_slang.word)
      expect(response_body[1]['definition']).to eq(third_slang.definition)
      expect(response_body[1]['is_approved']).to eq(third_slang.is_approved)
    end

    it 'returns a list of slangs with query' do
      get '/api/v1/search?q=new'

      expect(response).to have_http_status(:success)
      expect(response_body.size).to eq(1)
      expect(response_body[0]['id']).to eq(third_slang.id)
      expect(response_body[0]['word']).to eq(third_slang.word)
      expect(response_body[0]['definition']).to eq(third_slang.definition)
      expect(response_body[0]['is_approved']).to eq(third_slang.is_approved)
    end
  end
end
