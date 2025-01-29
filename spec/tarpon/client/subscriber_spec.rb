# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Tarpon::Client do
  let(:app_user_id) { 'app-user-id' }

  describe '.subscriber' do
    describe '.get_or_create' do
      it_behaves_like 'an http call to RevenueCat responding with subscriber object', method: :get, api_key: :public do
        let(:client_call) { described_class.subscriber(app_user_id).get_or_create }
        let(:uri) { "#{described_class.base_uri}/subscribers/#{app_user_id}" }
      end
    end

    describe '.attributes' do
      it_behaves_like 'an http call to RevenueCat', method: :post, api_key: :public, response: :custom do
        let(:uri) { "#{described_class.base_uri}/subscribers/#{app_user_id}/attributes" }
        let(:attributes) do
          {
            '$email': {
              value: 'test@example.com'
            }
          }
        end
        let(:body) do
          {
            attributes: attributes
          }
        end
        let(:client_call) { described_class.subscriber(app_user_id).attributes.update(**attributes) }
        let(:response) { '' }
        let(:response_expectation) do
          lambda do |r|
            expect(r.raw).to be_empty
            expect(r.subscriber).to be_nil
          end
        end
      end
    end

    describe '.delete' do
      it_behaves_like 'an http call to RevenueCat', method: :delete, api_key: :secret, response: :custom do
        let(:client_call) { described_class.subscriber(app_user_id).delete }

        let(:uri) { "https://api.revenuecat.com/v1/subscribers/#{app_user_id}" }
        let(:response) { JSON.generate(app_user_id: app_user_id) }
        let(:response_expectation) do
          lambda do |r|
            expect(r.raw).to eq(app_user_id: app_user_id)
            expect(r.subscriber).to be_nil
          end
        end
      end
    end

    describe '.entitlements' do
      let(:entitlement_id) { 'premium' }
      let(:entitlement) { described_class.subscriber(app_user_id).entitlements(entitlement_id) }

      describe '.grant_promotional' do
        context 'with duration and start_time_ms' do
          it_behaves_like 'an http call to RevenueCat responding with subscriber object',
                          method: :post, api_key: :secret do
            let(:body) { { duration: 'weekly', start_time_ms: 123 } }
            let(:client_call) { entitlement.grant_promotional(**body) }
            let(:uri) do
              "#{described_class.base_uri}/subscribers/#{app_user_id}/entitlements/#{entitlement_id}/promotional"
            end
          end
        end

        context 'with end_time_ms' do
          it_behaves_like 'an http call to RevenueCat responding with subscriber object',
                          method: :post, api_key: :secret do
            let(:body) { { end_time_ms: 123 } }
            let(:client_call) { entitlement.grant_promotional(**body) }
            let(:uri) do
              "#{described_class.base_uri}/subscribers/#{app_user_id}/entitlements/#{entitlement_id}/promotional"
            end
          end
        end
      end

      describe '.revoke_promotional' do
        it_behaves_like 'an http call to RevenueCat responding with subscriber object',
                        method: :post, api_key: :secret do
          let(:client_call) { entitlement.revoke_promotional }
          let(:uri) do
            "#{described_class.base_uri}/subscribers/#{app_user_id}/entitlements/#{entitlement_id}/revoke_promotionals"
          end
        end
      end
    end

    describe '.delete' do
      it_behaves_like 'an http call to RevenueCat', method: :delete, api_key: :secret, response: :custom do
        let(:client_call) { described_class.subscriber(app_user_id).delete }
        let(:uri) { "https://api.revenuecat.com/v1/subscribers/#{app_user_id}" }
        let(:response) { JSON.generate(app_user_id: app_user_id) }
        let(:response_expectation) do
          lambda do |r|
            expect(r.raw).to eq(app_user_id: app_user_id)
            expect(r.subscriber).to be_nil
          end
        end
      end
    end

    describe '.offerings' do
      let(:platform) { 'ios' }

      it_behaves_like 'an http call to RevenueCat',
                      method: :get, api_key: :public, response: :custom do
        let(:client_call) { described_class.subscriber(app_user_id).offerings.list(platform) }
        let(:uri) do
          "#{described_class.base_uri}/subscribers/#{app_user_id}/offerings"
        end
        let(:response) do
          File.read('spec/fixtures/offerings.json')
        end
        let(:response_expectation) do
          lambda do |r|
            expect(r.current_offering_id).to eq('standard')
            expect(r[:standard]).not_to be_nil
            expect(r['standard'].packages.first.identifier).to eq('$rc_monthly')
          end
        end
      end
    end

    describe '.subscriptions' do
      let(:product_id) { 'monthly' }
      let(:product) { described_class.subscriber(app_user_id).subscriptions(product_id) }

      describe '.defer' do
        it_behaves_like 'an http call to RevenueCat responding with subscriber object',
                        method: :post, api_key: :secret do
          let(:body) { { expiry_time_ms: 123_45 } }
          let(:client_call) { product.defer(**body) }
          let(:uri) { "#{described_class.base_uri}/subscribers/#{app_user_id}/subscriptions/#{product_id}/defer" }
        end
      end
    end
  end
end
