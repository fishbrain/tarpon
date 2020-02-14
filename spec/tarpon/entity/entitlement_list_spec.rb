require 'spec_helper'
require 'tarpon/entity/subscriber'

RSpec.describe Tarpon::Entity::EntitlementList do
  subject { described_class.new(entitlements) }

  let(:entitlements) {
    {
      'premium-entitlement-1' => attributes_for(:entitlement),
      'premium-entitlement-2' => attributes_for(:active_entitlement),
      'premium-entitlement-3' => attributes_for(:active_entitlement),
    }
  }

  describe '#active' do
    it 'returns only active entitlements (expires_date > now)' do
      expect(subject.active.map(&:id)).to contain_exactly('premium-entitlement-2', 'premium-entitlement-3')
    end
  end

  describe '#[]' do
    it 'returns corresponding entitlements based on index' do
      expect(subject[0].id).to eq('premium-entitlement-1')
      expect(subject[1].id).to eq('premium-entitlement-2')
      expect(subject[2].id).to eq('premium-entitlement-3')
    end
  end

  describe '#each' do
    it 'iterates through array of entitlements' do
      subject.each do |entitlement|
        expect(entitlement).to be_a(Tarpon::Entity::Entitlement)
      end
    end
  end
end
