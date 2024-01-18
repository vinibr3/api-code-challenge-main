require 'rails_helper'

RSpec.describe Hostname, type: :model do
  let(:hostname) { build_stubbed(:hostname) }

  it 'has a valid factory' do
    expect(hostname).to be_valid
  end

  it { is_expected.to(belong_to(:dns_record)) }
  it { is_expected.to(validate_presence_of(:hostname)) }
  it { expect(create(:hostname)).to(validate_uniqueness_of(:hostname).scoped_to(:dns_record_id)) }
end
