class GroupsController < ApplicationController
before_action :authenticate_user! , only: [:new, :create, :edit, :update, :destroy, :join, :quit]
before_action :find_group_and_check_permission, only: [:eidt, :update, :destroy]
# 使用GET
  #實作首頁
  def index
    @groups = Group.all
  end
  #各討論版專屬介面
  def show
    @group = Group.find(params[:id])
    @posts = @group.posts.recent.paginate(:page => params[:page], :per_page => 5)
  end
  #新增討論區用的'新增頁面'
  def new
    @group = Group.new
  end
  #編輯討論區用的'編輯頁面'
  def edit
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
    if @group.update(group_params)
      redirect_to groups_path, notice: "Update Success"
    else
      render :edit
    end
  end

#使用DELETE
  #刪除討論區表單（資料）
  def destroy
    @group.destroy
    flash[:alert] = "Group deleted"
    redirect_to groups_path
  end
  def join
    @group =Group.find(params[:id])

    if !current_user.is_member_of?(@group)
      current_user.join!(@group)
      flash[:notice] = "加入本討論版成功！"
    else
      flash[:warning] = "你已經是本討論版成員了！"
    end

    redirect_to group_path(@group)
  end

  def quit
    @group = Group.find(params[:id])

    if current_user.is_member_of?(@group)
      current_user.quit!(@group)
      flash[:alert] = "已退出本討論版！"
    else
      flash[:warning] = "你不是本討論版成員，怎麼退出 XD"
    end
  end

  private
  def find_group_and_check_permission
    @group = Group.find(params[:id])
    if current_user != @group.user
      redirect_to root_path, alert: "You have no permission"
    end
  end
  def group_params
    params.require(:group).permit(:title, :description)
  end
end
