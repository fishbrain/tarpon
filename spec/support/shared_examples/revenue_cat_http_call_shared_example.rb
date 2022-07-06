# frozen_string_literal: true

def stub_rc_request(method:, api_key:, uri:, client:, headers: {}, body: '') # rubocop:disable Metrics/ParameterLists
  default_headers = {
    'Accept' => 'application/json',
    'Authorization' => "Bearer #{client.send("#{api_key}_api_key")}",
    'Content-type' => 'application/json'
  }
  headers.merge!(default_headers)
  stub_request(method, uri).with(headers: headers, body: body)
end

RSpec.shared_examples 'an http call to RevenueCat' do |options|
  let(:stubbed_request) do
    stub_rc_request(
      method: options[:method],
      api_key: options[:api_key],
      headers: defined?(headers) ? headers : {},
      body: defined?(body) ? JSON.generate(body) : nil,
      uri: uri,
      client: client
    )
  end

  let(:client) { described_class }

  it 'has a configured API key' do
    expect(client.send("#{options[:api_key]}_api_key")).to_not be_nil
  end

  context 'when server responds with 404' do
    before { stubbed_request.to_return(status: 404) }

    it 'raises Tarpon::NotFoundError' do
      expect { client_call }.to raise_error(Tarpon::NotFoundError)
    end
  end

  context 'when server responds with 5xx' do
    before { stubbed_request.to_return(status: 500) }

    it 'raises Tarpon::ServerError' do
      expect { client_call }.to raise_error(Tarpon::ServerError)
    end
  end

  context 'when request has invalid credentials' do
    before { stubbed_request.to_return(status: 401) }

    it 'raises Tarpon::InvalidCredentialsError' do
      expect { client_call }.to raise_error(Tarpon::InvalidCredentialsError)
    end
  end

  context 'when request times out' do
    before { stubbed_request.to_timeout }

    it 'raises Tarpon::TimeoutError' do
      expect { client_call }.to raise_error(Tarpon::TimeoutError)
    end
  end

  context 'when server responds with bad request status code' do
    before { stubbed_request.to_return(status: 400, body: JSON.generate(message: 'message')) }

    it 'maps response to internal response object' do
      r = client_call

      expect(r).not_to be_success
      expect(r.raw[:message]).to eq('message')
      expect(r.message).to eq(r.raw[:message])
    end
  end

  context 'when request is successful' do
    let(:double_subscriber) { double('Tarpon::Entity::Subscriber') }
    let(:subscriber) { { entitlements: { premium: attributes_for(:entitlement) } } }
    let(:default_response) { JSON.generate(subscriber: subscriber) }

    before do
      stubbed_request.to_return(status: 200, body: defined?(response) ? response : default_response)

      if options[:response] == :subscriber
        expect(Tarpon::Entity::Subscriber).to receive(:new).with(subscriber).and_return(double_subscriber)
      end
    end

    it 'maps response to internal response object' do
      r = client_call

      if options[:response] == :custom && defined?(response_expectation)
        response_expectation.call(r)
      else
        expect(r).to be_success
        expect(r.raw).to eq(subscriber: subscriber)
        expect(r.subscriber).to eq(double_subscriber)
      end
    end
  end
end

RSpec.shared_examples 'an http call to RevenueCat responding with subscriber object' do |options|
  include_examples 'an http call to RevenueCat', options.merge(response: :subscriber)
end
