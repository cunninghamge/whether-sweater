require 'rails_helper'

RSpec.describe 'user post request' do
  it 'creates a user' do
    headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}
    user_params = attributes_for(:user)

    expect(User.count).to eq(0)

    post '/api/v1/users', headers: headers, params: JSON.generate(user_params)
    expect(response.status).to eq(201)

    expect(User.count).to eq(1)
    new_user = User.last
    expect(new_user.email).to eq(user_params[:email])

    data  = JSON.parse(response.body, symbolize_names: true)
    expect(data).to be_a(Hash)
    check_hash_structure(data, :data, Hash)
    check_hash_structure(data[:data], :id, String)
    expect(data[:data][:id]).to eq(new_user.id.to_s)
    check_hash_structure(data[:data], :type, String)
    expect(data[:data][:type]).to eq('user')
    check_hash_structure(data[:data], :attributes, Hash)
    check_hash_structure(data[:data][:attributes], :email, String)
    expect(data[:data][:attributes][:email]).to eq(new_user.email)
    check_hash_structure(data[:data][:attributes], :api_key, String)
  end

  it 'returns an error if the email is not unique' do
    headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}
    user_params = attributes_for(:user)
    create(:user, email: user_params[:email])

    expect(User.count).to eq(1)

    post '/api/v1/users', headers: headers, params: JSON.generate(user_params)

    expect(User.count).to eq(1)

    expect(response.status).to eq(400)
    errors = JSON.parse(response.body, symbolize_names: true)
    expect(errors).to be_a(Hash)
    expect(errors.keys).to match_array(%i[errors])
    check_hash_structure(errors, :errors, Array)
    expect(errors[:errors][0]).to be_a(String)
  end

  it 'returns an error if the email is missing' do
    headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}
    user_params = attributes_for(:user).except(:email)

    expect(User.count).to eq(0)

    post '/api/v1/users', headers: headers, params: JSON.generate(user_params)

    expect(User.count).to eq(0)

    expect(response.status).to eq(400)
    errors = JSON.parse(response.body, symbolize_names: true)
    expect(errors).to be_a(Hash)
    expect(errors.keys).to match_array(%i[errors])
    check_hash_structure(errors, :errors, Array)
    expect(errors[:errors][0]).to be_a(String)
  end

  it 'returns an error if the password is missing' do
    headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}
    user_params = attributes_for(:user).except(:password)

    expect(User.count).to eq(0)

    post '/api/v1/users', headers: headers, params: JSON.generate(user_params)

    expect(User.count).to eq(0)

    expect(response.status).to eq(400)
    errors = JSON.parse(response.body, symbolize_names: true)
    expect(errors).to be_a(Hash)
    expect(errors.keys).to match_array(%i[errors])
    check_hash_structure(errors, :errors, Array)
    expect(errors[:errors][0]).to be_a(String)
  end

  it 'returns an error if the password confirmation is missing' do
    headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}
    user_params = attributes_for(:user).except(:password_confirmation)

    expect(User.count).to eq(0)

    post '/api/v1/users', headers: headers, params: JSON.generate(user_params)

    expect(User.count).to eq(0)

    expect(response.status).to eq(400)
    errors = JSON.parse(response.body, symbolize_names: true)
    expect(errors).to be_a(Hash)
    expect(errors.keys).to match_array(%i[errors])
    check_hash_structure(errors, :errors, Array)
    expect(errors[:errors][0]).to be_a(String)
  end

  it 'returns an error if the passwords do not match' do
    headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}
    user_params = attributes_for(:user)
    user_params[:password_confirmation] = 'NOMATCH'

    expect(User.count).to eq(0)

    post '/api/v1/users', headers: headers, params: JSON.generate(user_params)

    expect(User.count).to eq(0)

    expect(response.status).to eq(400)
    errors = JSON.parse(response.body, symbolize_names: true)
    expect(errors).to be_a(Hash)
    expect(errors.keys).to match_array(%i[errors])
    check_hash_structure(errors, :errors, Array)
    expect(errors[:errors][0]).to be_a(String)
  end

  it 'returns an error if the user info is sent as query params' do
    headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}
    user_params = attributes_for(:user)

    expect(User.count).to eq(0)

    post "/api/v1/users?email=#{user_params[:email]}&password=#{user_params[:password]}&password_confirmation=#{user_params[:password_confirmation]}", headers: headers, params: JSON.generate(user_params)

    expect(User.count).to eq(0)

    expect(response.status).to eq(400)
    errors = JSON.parse(response.body, symbolize_names: true)
    expect(errors).to be_a(Hash)
    expect(errors.keys).to match_array(%i[errors])
    check_hash_structure(errors, :errors, Array)
    expect(errors[:errors][0]).to be_a(String)
  end

  describe 'returns an error if the headers are missing' do
    it 'content type' do
      headers = {'ACCEPT' => 'application/json'}
      user_params = attributes_for(:user)

      expect(User.count).to eq(0)

      post '/api/v1/users', headers: headers, params: JSON.generate(user_params)

      expect(User.count).to eq(0)

      expect(response.status).to eq(400)
      errors = JSON.parse(response.body, symbolize_names: true)
      expect(errors).to be_a(Hash)
      expect(errors.keys).to match_array(%i[errors])
      check_hash_structure(errors, :errors, Array)
      expect(errors[:errors][0]).to be_a(String)
    end

    it 'accept' do
      headers = {'CONTENT_TYPE' => 'application/json'}
      user_params = attributes_for(:user)

      expect(User.count).to eq(0)

      post '/api/v1/users', headers: headers, params: JSON.generate(user_params)

      expect(User.count).to eq(0)

      expect(response.status).to eq(400)
      errors = JSON.parse(response.body, symbolize_names: true)
      expect(errors).to be_a(Hash)
      expect(errors.keys).to match_array(%i[errors])
      check_hash_structure(errors, :errors, Array)
      expect(errors[:errors][0]).to be_a(String)
    end
  end
end
