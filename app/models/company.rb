class Company < ApplicationRecord
  has_many :orders_as_customer, class_name: "Order", foreign_key: "customer_id"
  has_many :orders_as_provider, class_name: "Order", foreign_key: "provider_id"

end
