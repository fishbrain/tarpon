require 'spec_helper'
require 'tarpon/client'

def stub_rc_request(method:, api_key:, uri:, headers: {}, body: '')
  default_headers = {
    'Accept' => 'application/json',
    'Authorization' => "Bearer #{described_class.send(api_key.to_s + '_api_key')}",
    'Content-type' => 'application/json',
  }
  headers.merge!(default_headers)
  stub_request(method, uri).with(headers: headers, body: body)
end

RSpec.describe Tarpon::Client do
  let(:app_user_id) { 'app-user-id' }

  describe '.subscriber' do
    subject { described_class.subscriber(app_user_id) }

    describe '.get_or_create' do
      let(:double_subscriber) { double('Tarpon::Entity::Subscriber') }
      let(:subscriber) { { entitlements: { :premium => attributes_for(:entitlement) } } }
      let(:response) { JSON.generate(subscriber: subscriber) }

      before do
        stub_rc_request(
          method: :get,
          api_key: :public,
          uri: "https://api.revenuecat.com/v1/subscribers/#{app_user_id}"
        ).to_return(status: 200, body: response)

        expect(Tarpon::Entity::Subscriber).to receive(:new).with(subscriber).and_return(double_subscriber)
      end

      it 'returns a response object' do
        r = subject.get_or_create

        expect(r.raw).to eq(subscriber: subscriber)
        expect(r.subscriber).to eq(double_subscriber)
      end
    end

    describe '.delete' do
      let(:response) { JSON.generate(app_user_id: app_user_id) }

      before do
        stub_rc_request(
          method: :delete,
          api_key: :secret,
          uri: "https://api.revenuecat.com/v1/subscribers/#{app_user_id}"
        ).to_return(status: 200, body: response)
      end

      it 'returns a response object' do
        r = subject.delete
        expect(r.raw).to eq(app_user_id: app_user_id)
        expect(r.subscriber).to be_nil
      end
    end

    describe '.entitlements' do
      subject { described_class.subscriber(app_user_id).entitlements(entitlement_id) }

      let(:entitlement_id) { 'premium' }

      describe '.grant_promotional' do
        let(:double_subscriber) { double('Tarpon::Entity::Subscriber') }
        let(:subscriber) { { entitlements: { :premium => attributes_for(:entitlement) } } }
        let(:request) { { duration: 'weekly', start_time_ms: 123 } }
        let(:response) { JSON.generate(subscriber: subscriber) }

        before do
          stub_rc_request(
            method: :post,
            api_key: :secret,
            uri: "https://api.revenuecat.com/v1/subscribers/#{app_user_id}/entitlements/#{entitlement_id}/promotional",
            body: JSON.generate(request)
          ).to_return(status: 200, body: response)
          expect(Tarpon::Entity::Subscriber).to receive(:new).with(subscriber).and_return(double_subscriber)
        end

        it 'returns a response object' do
          r = subject.grant_promotional(request)
          expect(r.raw).to eq(subscriber: subscriber)
          expect(r.subscriber).to eq(double_subscriber)
        end
      end

      describe '.revoke_promotional' do
        let(:double_subscriber) { double('Tarpon::Entity::Subscriber') }
        let(:subscriber) { { entitlements: { :premium => attributes_for(:entitlement) } } }
        let(:response) { JSON.generate(subscriber: subscriber) }

        before do
          stub_rc_request(
            method: :post,
            api_key: :secret,
            uri: "https://api.revenuecat.com/v1/subscribers/#{app_user_id}/entitlements/#{entitlement_id}/revoke_promotionals"
          ).to_return(status: 200, body: response)
          expect(Tarpon::Entity::Subscriber).to receive(:new).with(subscriber).and_return(double_subscriber)
        end

        it 'returns a response object' do
          r = subject.revoke_promotional
          expect(r.raw).to eq(subscriber: subscriber)
          expect(r.subscriber).to eq(double_subscriber)
        end
      end
    end
  end

  describe '.receipt' do
    subject { described_class.receipt }

    describe '.create' do
      let(:double_subscriber) { double('Tarpon::Entity::Subscriber') }
      let(:subscriber) { { entitlements: { :premium => attributes_for(:entitlement) } } }
      let(:platform) { 'ios' }
      let(:request) do
        {
          app_user_id: app_user_id,
          fetch_token: 'fetch-token',
        }
      end
      let(:response) { JSON.generate(subscriber: subscriber) }

      before do
        stub_rc_request(
          method: :post,
          api_key: :public,
          headers: { 'X-Platform' => platform },
          body: JSON.generate(request),
          uri: "https://api.revenuecat.com/v1/receipts"
        ).to_return(status: 200, body: response)
        expect(Tarpon::Entity::Subscriber).to receive(:new).with(subscriber).and_return(double_subscriber)
      end

      it 'returns a response object' do
        r = subject.create(platform: platform, **request)
        expect(r.raw).to eq(subscriber: subscriber)
        expect(r.subscriber).to eq(double_subscriber)
      end
    end
  end
end
