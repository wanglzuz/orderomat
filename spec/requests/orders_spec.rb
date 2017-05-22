require 'rails_helper'

RSpec.describe "Orders", type: :request do

  describe "authentication" do
    context "only when access_token is valid" do
      it "gives access" do

        company1 = Company.create(access_token: "ac3b5afd-cca6-4ed6-aabb-0169e29237ad")
        company2 = Company.create(access_token: "eb6feed2-78ff-4bbf-898f-43b4c5e7bcb5")
        description = "Test order."
        deadline = 1.week.from_now


        post "/orders", :headers => {"HTTP_ACCESS_TOKEN" => "ac3b5afd-cca6-4ed6-aabb-0169e29237ad"},
                        :params => {"provider_id" => company2.id, "description" => description,
                                    "deadline" => deadline}
        expect(response).to have_http_status 201

        post "/orders", :headers => {"HTTP_ACCESS_TOKEN" => "krokodyl"},
                        :params => {"provider_id" => company2.id, "description" => description,
                                    "deadline" => deadline}
        expect(response).to have_http_status 401

        post "/orders", :params => {"provider_id" => company2.id, "description" => description,
                                    "deadline" => deadline}

        expect(response).to have_http_status 401



        expect(Order.count).to eq 1

      end
    end
  end

  describe "POST /orders" do
    context "when I send order to a different company" do
      it "saves article into the database" do

        company1 = Company.create(access_token: "ac3b5afd-cca6-4ed6-aabb-0169e29237ad")
        company2 = Company.create(access_token: "eb6feed2-78ff-4bbf-898f-43b4c5e7bcb5")
        description = "Test order."
        deadline = 1.week.from_now

        post "/orders", :headers => {"HTTP_ACCESS_TOKEN" => company1.access_token},
                        :params => {"provider_id" => company2.id, "description" => description,
                                    "deadline" => deadline}

        expect(response).to have_http_status 201
        expect(Order.count).to eq 1
        order = Order.first
        expect(order.customer).to eq company1
        expect(order.provider).to eq company2
        expect(order.description).to eq description
        expect(order.deadline.to_s).to eq deadline.to_s
        #TODO: 3)


      end
    end

    context "when company sends order to itself" do
      it "sends response 400" do

        company1 = Company.create(access_token: "ac3b5afd-cca6-4ed6-aabb-0169e29237ad")
        description = "Test order."
        deadline = 1.week.from_now

        post "/orders", :headers => {"HTTP_ACCESS_TOKEN" => company1.access_token},
             :params => {"provider_id" => company1.id, "description" => description,
                         "deadline" => deadline}

        expect(response).to have_http_status 400
        expect(Order.count).to eq 0

      end
    end

    context "when some required parameters are missing" do
      it "sends response 400" do

        company1 = Company.create(access_token: "ac3b5afd-cca6-4ed6-aabb-0169e29237ad")
        company2 = Company.create(access_token: "eb6feed2-78ff-4bbf-898f-43b4c5e7bcb5")
        description = "Test order."
        deadline = 1.week.from_now

        post "/orders", :headers => {"HTTP_ACCESS_TOKEN" => company1.access_token},
             :params => {"provider_id" => company2.id, "description" => description}

        expect(response).to have_http_status 400
        expect(Order.count).to eq 0

        post "/orders", :headers => {"HTTP_ACCESS_TOKEN" => company1.access_token},
             :params => {"provider_id" => company2.id, "deadline" => deadline}

        expect(response).to have_http_status 400
        expect(Order.count).to eq 0

        post "/orders", :headers => {"HTTP_ACCESS_TOKEN" => company1.access_token},
             :params => {"description" => description, "deadline" => deadline}

        expect(response).to have_http_status 400
        expect(Order.count).to eq 0

      end
    end

    context "when I send in redundant info" do
      it "ignores it and saves the order with my customer ID, correct time of creation and status" do

        company1 = Company.create(access_token: "ac3b5afd-cca6-4ed6-aabb-0169e29237ad")
        company2 = Company.create
        company3 = Company.create
        description = "Test order."
        deadline = 1.week.from_now
        created = 3.weeks.ago
        status = :accepted

        post "/orders", :headers => {"HTTP_ACCESS_TOKEN" => company1.access_token},
             :params => {"customer_id" => company3.id, "provider_id" => company2.id,
                         "description" => description, "deadline" => deadline,
                         "created" => created, "status" => status}

        expect(response).to have_http_status 201
        expect(Order.count).to eq 1
        order = Order.first
        expect(order.customer).to eq company1
        expect(order.status).to eq "created"

      end
    end
  end

  describe "PUT /orders/:id" do

    context "when the requested status is 'in_process' or 'sent_out'" do
      it "only provider can set this up" do

        company1 = Company.create(access_token: "ac3b5afd-cca6-4ed6-aabb-0169e29237ad")
        company2 = Company.create(access_token: "eb6feed2-78ff-4bbf-898f-43b4c5e7bcb5")
        order1 = Order.create(customer: company1, provider: company2, description: "Test.",
                              created: DateTime.now, deadline: 1.week.from_now, status: :created)

        put "/orders/#{order1.id}", :headers => {"HTTP_ACCESS_TOKEN" => company1.access_token},
                                   :params => {"status" => :in_process}
        expect(response).to have_http_status 400
        order1.reload
        expect(order1.status).to eq "created"

        put "/orders/#{order1.id}", :headers => {"HTTP_ACCESS_TOKEN" => company1.access_token},
            :params => {"status" => :sent_out}
        expect(response).to have_http_status 400
        order1.reload
        expect(order1.status).to eq "created"

        put "/orders/#{order1.id}", :headers => {"HTTP_ACCESS_TOKEN" => company2.access_token},
            :params => {"status" => :in_process}
        expect(response).to have_http_status 200
        order1.reload
        expect(order1.status).to eq "in_process"

        put "/orders/#{order1.id}", :headers => {"HTTP_ACCESS_TOKEN" => company2.access_token},
            :params => {"status" => :sent_out}
        expect(response).to have_http_status 200
        order1.reload
        expect(order1.status).to eq "sent_out"

      end
    end

    context "when the requested status is 'accepted'" do
      it "only customer can set this up" do

        company1 = Company.create(access_token: "ac3b5afd-cca6-4ed6-aabb-0169e29237ad")
        company2 = Company.create(access_token: "eb6feed2-78ff-4bbf-898f-43b4c5e7bcb5")
        order1 = Order.create(customer: company1, provider: company2, description: "Test.",
                              created: DateTime.now, deadline: 1.week.from_now, status: :created)

        put "/orders/#{order1.id}", :headers => {"HTTP_ACCESS_TOKEN" => company2.access_token},
            :params => {"status" => :accepted}
        expect(response).to have_http_status 400
        order1.reload
        expect(order1.status).to eq "created"

        put "/orders/#{order1.id}", :headers => {"HTTP_ACCESS_TOKEN" => company1.access_token},
            :params => {"status" => :accepted}
        expect(response).to have_http_status 200
        order1.reload
        expect(order1.status).to eq "accepted"

      end
    end

    context "when the requested status is anything else / none" do
      it "returns 400 and does not change the status" do

        company1 = Company.create(access_token: "ac3b5afd-cca6-4ed6-aabb-0169e29237ad")
        company2 = Company.create(access_token: "eb6feed2-78ff-4bbf-898f-43b4c5e7bcb5")
        order1 = Order.create(customer: company1, provider: company2, description: "Test.",
                              created: DateTime.now, deadline: 1.week.from_now, status: :accepted)

        put "/orders/#{order1.id}", :headers => {"HTTP_ACCESS_TOKEN" => company1.access_token},
            :params => {"status" => :created}
        expect(response).to have_http_status 400
        order1.reload
        expect(order1.status).to eq "accepted"

        put "/orders/#{order1.id}", :headers => {"HTTP_ACCESS_TOKEN" => company1.access_token},
            :params => {"status" => "krokodyl"}
        expect(response).to have_http_status 400
        order1.reload
        expect(order1.status).to eq "accepted"

        put "/orders/#{order1.id}", :headers => {"HTTP_ACCESS_TOKEN" => company1.access_token}
        expect(response).to have_http_status 400
        order1.reload
        expect(order1.status).to eq "accepted"

      end
    end

  end




end
