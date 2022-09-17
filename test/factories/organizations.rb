# frozen_string_literal: true

FactoryBot.define do
  factory :organizo, class: :organization do
    name { Faker::Company.name }
    short_name { Faker::Internet.domain_word }
    city { Faker::Address.city }
    country { Country.all.sample }
    email { Faker::Internet.email }
  end

  factory :bejo, class: :organization do
    name { 'Brazila Esperanta Junulara Organizo' }
    short_name { 'BEJO' }
    city { 'São Paulo' }
    country { Country.all.sample }
    email { 'bejo@bejo.org.br' }
  end

  factory :tejo, class: :organization do
    name { 'Tutmonda Esperanta Junulara Organizo' }
    short_name { 'TEJO' }
    city { Faker::Address.city }
    country { Country.all.sample }
    email { Faker::Internet.email }
  end
end
