class AddConfirmationTokenAndConfirmationTokenSendAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmation_token_send_at, :date
  end
end
