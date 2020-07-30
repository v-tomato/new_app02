class AddActivationToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :activation_digest, :string
    # デフォルトでは管理者になれないということを示すため
    add_column :users, :activated, :boolean, default: false
  end
end
