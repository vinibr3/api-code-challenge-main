class DnsRecord < ApplicationRecord
  has_many :hostnames, dependent: :destroy

  validates :ip, presence: true,
                 format: { with: IPV4_REGEXP }

  accepts_nested_attributes_for :hostnames, allow_destroy: true,
                                            reject_if: :all_blank

  before_save :cleasing

  def serialize
    {
      id: id,
      ip_address: ip
    }
  end

  def related_hostnames
    hostnames.map {|h| {count: 1, hostname: hostname} }
  end

  private

  def cleasing
    self.ip = ip.strip.downcase if ip
  end
end
