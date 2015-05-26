ActiveAdmin.register Category do
  actions :all, :except => [:show]

  index do
    column :name do |category|
      category.try(:name)
    end
    default_actions
  end

  controller do
    def destroy
      category = Category.find(params[:id])

      if !category.destroy
        flash[:error] = category.errors.full_messages.join(' / ')
      end
      redirect_to admin_categories_path
    end
  end
end
