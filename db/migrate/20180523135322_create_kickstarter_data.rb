class CreateKickstarterData < ActiveRecord::Migration[5.2]
  def change
    create_table :kickstarter_datas do |t|
      t.string :country
      t.string :category

      t.integer :year
      t.integer :month

      t.integer :backers_count
      t.float :usd_pledged
      t.float :avg_pledge

      t.string :url
      t.integer :record_id
    end

    add_index :kickstarter_datas, :record_id, unique: true
  end
end
