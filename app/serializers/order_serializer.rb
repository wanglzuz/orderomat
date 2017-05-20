class OrderSerializer < ActiveModel::Serializer
  attributes :id, :customer_id, :provider_id, :description, :created, :deadline, :status
end
