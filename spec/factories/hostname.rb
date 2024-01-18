FactoryBot.define do
  factory :hostname do
    hostname { Faker::Internet.domain_name }
    dns_record { association(:dns_record) }
  end
end
