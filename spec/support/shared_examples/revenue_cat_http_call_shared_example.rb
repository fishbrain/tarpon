def stub_rc_request(method:, api_key:, uri:, headers: {}, body: '')
  default_headers = {
    'Accept' => 'application/json',
    'Authorization' => "Bearer #{described_class.send(api_key.to_s + '_api_key')}",
    'Content-type' => 'application/json',
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
      uri: uri
    )
  end

  context 'when server responds with 5xx' do
    before { stubbed_request.to_return(status: 500) }

    it 'raises Tarpon::ServerError' do
      expect {
        base_call.send(*client_call)
      }.to raise_error(Tarpon::ServerError)
    end
  end

  context 'when request has invalid credentials' do
    before { stubbed_request.to_return(status: 401) }

    it 'raises Tarpon::InvalidCredentialsError' do
      expect {
        base_call.send(*client_call)
      }.to raise_error(Tarpon::InvalidCredentialsError)
    end
  end

  context 'when request times out' do
    before { stubbed_request.to_timeout }

    it 'raises Tarpon::TimeoutError' do
      expect {
        base_call.send(*client_call)
      }.to raise_error(Tarpon::TimeoutError)
    end
  end

  context 'when request is successful' do
    let(:double_subscriber) { double('Tarpon::Entity::Subscriber') }
    let(:subscriber) { { entitlements: { :premium => attributes_for(:entitlement) } } }
    let(:default_response) { JSON.generate(subscriber: subscriber) }

    before do
      stubbed_request.to_return(status: 200, body: defined?(response) ? response : default_response)
      expect(Tarpon::Entity::Subscriber).to receive(:new)
        .with(subscriber).and_return(double_subscriber) if options[:response] == :subscriber
    end

    it 'maps response to internal response object correctly' do
      r = base_call.send(*client_call)

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
