require 'rails_helper'

RSpec.describe DnsRecord, type: :model do
  let(:dns_record) { build_stubbed(:dns_record) }

  it 'has a valid factory' do
    expect(dns_record).to be_valid
  end

  it { is_expected.to(have_many(:hostnames).dependent(:destroy)) }
  it { is_expected.to(validate_presence_of(:ip)) }
  it { is_expected.to(accept_nested_attributes_for(:hostnames).allow_destroy(true)) }

  describe "when validates format of attribute 'ip'" do
    context 'with valid ip' do
      before { dns_record.valid? }

      it { expect(dns_record.errors[:ip]).to_not include('is invalid') }
    end

    context 'with invalid ip' do
      let(:dns_record) { build_stubbed(:dns_record, ip: Faker::Lorem.word) }

      before { dns_record.valid? }

      it { expect(dns_record.errors[:ip]).to include('is invalid') }
    end
  end
end
