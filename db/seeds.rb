# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


woodchuck  = Company.create({name: 'Woodchuck Inc.', ico: '123456789',
                             access_token: '82d972da-95c0-445a-80c3-bd232c1091da'})
toolsifier = Company.create({name: 'Toolsifier',     ico: '987654321',
                             access_token: 'ea1e4ba0-ac6d-4df6-b4cc-d6dbfc8eb7a0'})
eatnow     = Company.create({name: 'Eat Now!',      ico: '132457689',
                             access_token: '5aaa2d6e-af56-419c-a60e-f4ecd77ad6f0'})


order1 = Order.create({customer: woodchuck, provider: toolsifier,
                       description: "We need three new sharp axes.", created: DateTime.current,
                       deadline: 14.days.from_now, status: :created})

order2 = Order.create({customer: toolsifier, provider: eatnow,
                      description: "Three bagels with ham and cheese.", created: DateTime.current,
                       deadline: 3.days.from_now, status: :created})

order3 = Order.create({customer: woodchuck, provider: eatnow,
                       description: "Three bagels with ham and cheese.", created: 2.days.ago,
                       deadline: 1.day.from_now, status: :in_process})