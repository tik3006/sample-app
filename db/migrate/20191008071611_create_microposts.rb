class CreateMicroposts < ActiveRecord::Migration[5.2]
   def change
    create_table :microposts do |t|
      t.text :content
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :microposts, [ :user_id, :created_at ]                            # user_idとcreate_atカラムにインデックス(要素番号)を付与
  end
end
