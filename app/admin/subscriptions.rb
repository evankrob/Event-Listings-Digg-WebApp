ActiveAdmin.register Subscription do
  index do
    column :email do |sub|
      link_to sub.email, admin_subscription_path(sub)
    end
    column :frequency do |sub|
      sub.frequency.titleize if sub.frequency?
    end
    column :subscribed do |sub|
      sub.created_at.strftime('%B %e, %Y')
    end
    default_actions
  end

  show do
    attributes_table :email, :frequency, :search_criteria, :created_at
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :frequency
    end
    f.buttons
  end
end
