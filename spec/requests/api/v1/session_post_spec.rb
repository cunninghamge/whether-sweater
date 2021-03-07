require 'rails_helper'

RSpec.describe 'sessions post request' do
  it 'returns the user\'s api keyand email' do
    headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}
    user = create(:user)
    expect(User.count).to eq(1)

    login_params = { email: user.email, password: user.password }

    post '/api/v1/sessions', headers: headers, params: JSON.generate(login_params)

    expect(response.status).to eq(200)
    expect(User.count).to eq(1)

    data  = JSON.parse(response.body, symbolize_names: true)
    expect(data).to be_a(Hash)
    check_hash_structure(data, :data, Hash)
    check_hash_structure(data[:data], :id, String)
    expect(data[:data][:id]).to eq(user.id.to_s)
    check_hash_structure(data[:data], :type, String)
    expect(data[:data][:type]).to eq('user')
    check_hash_structure(data[:data], :attributes, Hash)
    check_hash_structure(data[:data][:attributes], :email, String)
    expect(data[:data][:attributes][:email]).to eq(user.email)
    check_hash_structure(data[:data][:attributes], :api_key, String)
  end

  it 'returns an error if the email can\'t be found' do
    headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}
    user = create(:user, email: 'user@example.com')
    login_params = { email: 'wrong_email@example.com', password: user.password }

    post '/api/v1/sessions', headers: headers, params: JSON.generate(login_params)

    expect(response.status).to eq(400)
    errors = JSON.parse(response.body, symbolize_names: true)
    expect(errors).to be_a(Hash)
    expect(errors.keys).to match_array(%i[errors])
    check_hash_structure(errors, :errors, Array)
    expect(errors[:errors][0]).to be_a(String)
    expect(errors[:errors][0]).to include('Invalid email or password')
  end

  it 'returns an error if the password is incorrect' do
    headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}
    user = create(:user, password: 'password123')
    login_params = { email: user.email, password: 'wrong_password' }

    post '/api/v1/sessions', headers: headers, params: JSON.generate(login_params)

    expect(response.status).to eq(400)
    errors = JSON.parse(response.body, symbolize_names: true)
    expect(errors).to be_a(Hash)
    expect(errors.keys).to match_array(%i[errors])
    check_hash_structure(errors, :errors, Array)
    expect(errors[:errors][0]).to be_a(String)
    expect(errors[:errors][0]).to include('Invalid email or password')
  end

  it 'returns an error if the email is missing' do
    headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}
    user = create(:user)
    login_params = { password: user.password }

    post '/api/v1/sessions', headers: headers, params: JSON.generate(login_params)

    expect(response.status).to eq(400)
    errors = JSON.parse(response.body, symbolize_names: true)
    expect(errors).to be_a(Hash)
    expect(errors.keys).to match_array(%i[errors])
    check_hash_structure(errors, :errors, Array)
    expect(errors[:errors][0]).to be_a(String)
    expect(errors[:errors][0]).to include('Invalid email or password')
  end

  it 'returns an error if the password is missing' do
    headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}
    user = create(:user)
    login_params = { email: user.email }

    post '/api/v1/sessions', headers: headers, params: JSON.generate(login_params)

    expect(response.status).to eq(400)
    errors = JSON.parse(response.body, symbolize_names: true)
    expect(errors).to be_a(Hash)
    expect(errors.keys).to match_array(%i[errors])
    check_hash_structure(errors, :errors, Array)
    expect(errors[:errors][0]).to be_a(String)
    expect(errors[:errors][0]).to include('Invalid email or password')
  end

  it 'returns an error if the user info is sent as query params' do
    headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}
    user = create(:user)

    login_params = { email: user.email, password: user.password }

    post "/api/v1/sessions?email=#{login_params[:email]}&password=#{login_params[:password]}", headers: headers, params: JSON.generate(login_params)

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
      user = create(:user)
      login_params = { email: user.email, password: user.password }

      post '/api/v1/sessions', headers: headers, params: JSON.generate(login_params)

      expect(response.status).to eq(400)
      errors = JSON.parse(response.body, symbolize_names: true)
      expect(errors).to be_a(Hash)
      expect(errors.keys).to match_array(%i[errors])
      check_hash_structure(errors, :errors, Array)
      expect(errors[:errors][0]).to be_a(String)
    end

    it 'accept' do
      headers = {'CONTENT_TYPE' => 'application/json'}
      user = create(:user)
      login_params = { email: user.email, password: user.password }

      post '/api/v1/sessions', headers: headers, params: JSON.generate(login_params)

      expect(response.status).to eq(400)
      errors = JSON.parse(response.body, symbolize_names: true)
      expect(errors).to be_a(Hash)
      expect(errors.keys).to match_array(%i[errors])
      check_hash_structure(errors, :errors, Array)
      expect(errors[:errors][0]).to be_a(String)
    end
  end
end
