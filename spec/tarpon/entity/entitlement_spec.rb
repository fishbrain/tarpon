# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Tarpon::Entity::Entitlement do
  subject { described_class.new(id, attributes) }

  let(:id) { 'entitlement-id' }
  let(:attributes) { attributes_for(:entitlement) }

  describe '#id' do
    it 'equals initialized id' do
      expect(subject.id).to eq id
    end
  end

  describe '#raw' do
    it 'equals initialized attributes' do
      expect(subject.raw).to eq attributes
    end
  end

  describe '#active?' do
    context 'when expires_date is in the future' do
      let(:attributes) { attributes_for(:active_entitlement) }

      it { is_expected.to be_active }
    end

    context 'when expires_date is the same as now' do
      let(:now) { Time.now.utc.iso8601 }
      let(:attributes) { attributes_for(:active_entitlement, expires_date: now, purchase_date: now) }

      it { is_expected.not_to be_active }
    end

    context 'when expires_date is in the past' do
      let(:now) { Time.now.utc.iso8601 }
      let(:attributes) { attributes_for(:active_entitlement, expires_date: now, purchase_date: now) }

      it { is_expected.not_to be_active }
    end
  end

  describe '#expires_date' do
    it 'parses the iso8601 expires_date' do
      expect(subject.expires_date).to eq Time.iso8601(attributes[:expires_date])
    end
  end
end
