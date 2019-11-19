class AddAdressToMicroposts < ActiveRecord::Migration[5.1]
  def change
    add_column :microposts, :git, :string
    add_column :microposts, :reset, :string
    add_column :microposts, :mix, :string
  end
end
