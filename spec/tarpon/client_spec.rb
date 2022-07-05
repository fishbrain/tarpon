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
          c.base_uri = 'https://example.com/client_1'
        end
      end
    end
  end
end
