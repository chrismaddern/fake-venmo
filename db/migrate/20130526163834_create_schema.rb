class CreateSchema < ActiveRecord::Migration
  def up
    create_table :cards do |t|
      t.string   :last_four
      t.string   :card_type
      t.string   :candidate
    end

    create_table :users do |t|
      t.string   :name
      t.string   :candidate
    end
  end

  def down
    drop_table :users
    drop_table :cards
  end
end
