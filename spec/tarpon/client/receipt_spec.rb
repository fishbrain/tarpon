# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Tarpon::Client do
  let(:app_user_id) { 'app-user-id' }

  describe '.receipt' do
    describe '.create' do
      it_behaves_like 'an http call to RevenueCat responding with subscriber object', method: :post, api_key: :public do
        let(:platform) { 'ios' }
        let(:headers) { { 'X-Platform' => platform } }
        let(:uri) { "#{described_class.base_uri}/receipts" }
        let(:body) do
          {
            app_user_id: app_user_id,
            fetch_token: 'fetch-token'
          }
        end
        let(:client_call) { described_class.receipt.create(platform: platform, **body) }
      end
    end
  end
end
