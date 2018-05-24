class CreateKickstarterData < ActiveRecord::Migration[5.2]
  def change
    create_table :kickstarter_datas do |t|
      t.string :country, null: false
      t.string :category, null: false

      t.integer :year, null: false
      t.integer :month, null: false

      t.integer :backers_count, null: false
      t.float :usd_pledged, null: false
      t.float :avg_pledge

      t.string :url, null: false
      t.integer :record_id, null: false

      t.datetime :state_changed_at, null: false
    end

    add_index :kickstarter_datas, :record_id, unique: true
  end
end
