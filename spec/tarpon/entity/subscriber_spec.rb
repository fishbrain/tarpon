require 'spec_helper'
require 'tarpon/entity/subscriber'

RSpec.describe Tarpon::Entity::Subscriber do
  subject { described_class.new(attributes) }

  let(:attributes) {
    {
      'entitlements' => {},
    }
  }

  describe '#raw' do
    it 'returns the raw attributes without modification' do
      expect(subject.raw).to eq attributes
    end
  end

  describe '#entitlements' do
    let(:entitlements_list) { double('Tarpon::Entity::EntitlementList') }

    before do
      expect(Tarpon::Entity::EntitlementList).to receive(:new)
        .with(attributes['entitlements'])
        .and_return(entitlements_list)
    end

    it 'returns an instance of EntitlementList' do
      expect(subject.entitlements).to eq entitlements_list
    end
  end
end
