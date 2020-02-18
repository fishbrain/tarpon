# frozen_string_literal: true

FactoryBot.define do
  factory :entitlement, class: Hash do
    expires_date { Time.now.utc.iso8601 }
    purchase_date { Time.now.utc.iso8601 }
    sequence(:product_identifier) { |n| "product-id-#{n}" }

    factory :active_entitlement, class: Hash do
      expires_date { (Time.now + 60).utc.iso8601 }
    end

    factory :expired_entitlement, class: Hash do
      expires_date { (Time.now - 1).utc.iso8601 }
    end
  end
end
