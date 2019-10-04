class AddRemenberDigestToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :remenber_digest, :string
  end
end 