class GroupsController < ApplicationController
before_action :authenticate_user! , only: [:new, :create, :edit, :update, :destroy]
# 使用GET
  #實作首頁
  def index
    @groups = Group.all
  end
  #各討論版專屬介面
  def show
    @group = Group.find(params[:id])
  end
  #新增討論區用的'新增頁面'
  def new
    @group = Group.new
  end
  #編輯討論區用的'編輯頁面'
  def edit
    @group = Group.find(params[:id])
    if current_user != @group.user
      redirect_to root_path, alert: "You have no permission"
    end
  end

#使用POST
  #產生討論區表單（資料）
  def create
    @group = Group.new(group_params)
    @group.user = current_user
    if @group.save
      redirect_to groups_path
    else
      render :new
    end
  end

#使用PUT
  #更新討論區表單（資料）
  def update
    @group = Group.find(params[:id])
    if current_user != @group.user
      redirect_to root_path, alert: "You have no permission"
    end
    if @group.update(group_params)
      redirect_to groups_path, notice: "Update Success"
    else
      render :edit
    end
  end

#使用DELETE
  #刪除討論區表單（資料）
  def destroy
    @group = Group.find(params[:id])
    if current_user != @group.user
      redirect_to root_path, alert: "You have no permission"
    end    
    @group.destroy
    flash[:alert] = "Group deleted"
    redirect_to groups_path
  end

  private
  def group_params
    params.require(:group).permit(:title, :description)
  end
end
