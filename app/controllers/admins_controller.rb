class AdminsController < ApplicationController
  def admin_panel
    if current_user.admin == true
    end
  end

  def edit
    @admin = Admin.find(params[:id])
    @users = User.all
  end

  def update
    @admin = Admin.find(params[:id])
    @admin.update(admin_params)
    redirect_to edit_admin_path(@admin)
  end

  private

  def admin_params
    params.require(:admin).permit(:pages)
  end
end
