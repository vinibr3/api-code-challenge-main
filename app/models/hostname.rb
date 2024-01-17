class Hostname < ApplicationRecord
  belongs_to :dns_record

  validates :hostname, presence: true,
                       hostname: true,
                       uniqueness: { scope: :dns_record_id }

  before_save :cleasing

  private

  def cleasing
    self.hostname = hostname.strip.downcase if hostname
  end
end
