class CreateDnsRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :dns_records do |t|
      t.string :ip, index: true, null: false, limit: 15

      t.timestamps
    end
  end
end
