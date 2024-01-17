class CreateHostnames < ActiveRecord::Migration[6.1]
  def change
    create_table :hostnames do |t|
      t.string :hostname, null: false, index: true
      t.references :dns_record, null: false, foreign_key: { to_table: :dns_records }

      t.timestamps
    end
  end
end
