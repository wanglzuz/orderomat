require "rails_helper"

RSpec.describe Order, :type => :model do

  describe "order association with company" do
    context "only when company is customer/provider" do
      it "allows order access" do

        company1 = Company.create!(id: 1)
        company2 = Company.create!(id: 2)
        company3 = Company.create!(id: 3)
        order1 = Order.create!(customer: company1, provider: company2)

        # expect(order1.is_associated(company1)).to eq true
        # expect(order1.is_associated(company2)).to eq true
        # expect(order1.is_associated(company3)).to eq false

        company1 = Company.find(id: 1)
        company2 = Company.find(id: 2)
        company3 = Company.find(id: 3)
        order1 = Order.find(customer: company1, provider: company2)

        expect(order1.is_associated(company1)).to eq true
        expect(order1.is_associated(company2)).to eq true
        expect(order1.is_associated(company3)).to eq false

      end
    end
  end



end