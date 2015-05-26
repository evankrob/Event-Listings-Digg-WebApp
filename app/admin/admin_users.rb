ActiveAdmin.register AdminUser, :as => 'Account' do
  index do
    column :email do |account|
      link_to account.email, edit_admin_account_path(account)
    end
    %w(sign_in_count current_sign_in_at last_sign_in_at).each do |method|
      column method do |account|
        account.send(method)
      end
    end
    default_actions
  end

  show do
    attributes_table :email, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
    end
    f.buttons
  end
end
