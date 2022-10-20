# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Tarpon::Client do
  let(:app_user_id) { 'app-user-id' }

  describe 'configuring different clients' do
    it_behaves_like 'an http call to RevenueCat responding with subscriber object', method: :get, api_key: :public do
      let(:client_call) { client.subscriber(app_user_id).get_or_create }
      let(:uri) { "https://example.com/client_1/subscribers/#{app_user_id}" }

      let(:client) do
        Tarpon::Client.new do |c|
          c.public_api_key = 'test-public-key'
          c.secret_api_key = 'test-secret-key'
          c.base_uri = 'https://example.com/client_1'
        end
      end
    end
  end

  it 'receives configuration values when instantiating' do
    http_middleware = ->(http_client) { http_client }

    subject = described_class.new(
      public_api_key: 'public-key',
      secret_api_key: 'secret-key',
      timeout: 3,
      base_uri: 'https://example.com',
      http_middleware: http_middleware
    )

    expect(subject.public_api_key).to eq('public-key')
    expect(subject.secret_api_key).to eq('secret-key')
    expect(subject.timeout).to eq(3)
    expect(subject.base_uri).to eq('https://example.com')
    expect(subject.http_middleware).to eq(http_middleware)
  end

  describe 'advanced HTTP request configuration' do
    let(:http_calls) { [] }
    let(:client) do
      Tarpon::Client.new do |c|
        c.http_middleware = lambda do |http_client|
          http_calls << http_client
          http_client
        end
      end
    end

    before { stub_request(:any, /api\.revenuecat\.com/) }

    it 'evaluates the HTTP config block on every request' do
      client.subscriber(app_user_id).get_or_create

      expect(http_calls).to include(an_instance_of(HTTP::Client))
    end
  end
end
