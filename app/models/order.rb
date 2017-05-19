class Order < ApplicationRecord
  belongs_to :customer, class_name: "Company"
  belongs_to :provider, class_name: "Company"
end
