ActiveRecord::Schema.define do
  self.verbose = false

  create_table :users, force: true do |t|
    t.string :name
    t.string :email, null: false
    t.datetime :birthday

    t.timestamps
  end
end
