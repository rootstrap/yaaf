ActiveRecord::Schema.define do
  self.verbose = false

  create_table :users, force: true do |t|
    t.string :name
    t.string :email, null: false
    t.datetime :birthday

    t.timestamps
  end

  create_table :comments, force: true do |t|
    t.integer :user_id, null: false
    t.string :text
  end
end
