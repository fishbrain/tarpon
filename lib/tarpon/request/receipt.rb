module Tarpon
  module Request
    class Receipt < Base
      def create(platform:, **data)
        headers = { 'X-Platform' => platform }
        perform(method: :post, headers: headers, path: '/receipts', key: :public, body: data)
      end
    end
  end
end
