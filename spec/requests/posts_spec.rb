require 'rails_helper'

RSpec.describe "Posts", type: :request do
  describe "GET /posts" do
    let!(:posts) { create_list(:post, 10) }

    before { get '/posts' }

    it 'should display all posts' do
      expect(response.body).to eq(Post.all.to_json)
    end

    it 'should return a successful response' do
      expect(response).to be_successful
    end
  end

  describe 'GET /posts/:id' do
    let!(:post) { create(:post) }

    before { get "/posts/#{post.id}" }

    it 'should display the correct post' do
      expect(response.body).to eq(post.to_json)
    end

    it 'should return a successful response' do
      expect(response).to be_successful
    end
  end

  describe 'POST /posts' do
    context 'with valid parameters' do
      let!(:valid_attributes) { { title: 'Post Title', content: 'Post content.' } }

      before { post '/posts', params: { post: valid_attributes } }

      it 'creates a new post' do
        expect(Post.count).to eq(1)
      end

      it 'returns a status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'should return the post' do
        expect(JSON.parse(response.body)['title']).to eq('Post Title')
        expect(JSON.parse(response.body)['content']).to eq('Post content.')
      end
    end

    context 'with invalid parameters' do
      let!(:invalid_attributes) { { title: nil, content: 'Post content.' } }

      before { post '/posts', params: { post: invalid_attributes } }

      it 'returns a status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT /posts/:id' do
    context 'with valid parameters' do
      let!(:post) { create(:post) }

      before { put "/posts/#{post.id}", params: { post: { title: 'Updated Title' } } }

      it 'should return a successful response' do
        expect(response).to be_successful
      end

      it 'should update the post' do
        expect(Post.first.title).to eq('Updated Title')
      end
    end

    context 'with invalid parameters' do
      let!(:post) { create(:post) }

      before { put "/posts/#{post.id}", params: { post: { title: nil } } }

      it 'returns a status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /posts/:id' do
    let!(:post) { create(:post) }

    before { delete "/posts/#{post.id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(:no_content)
    end

    it 'returns the deleted post data' do
      expect(response.body).to eq('')
    end
  end
end
