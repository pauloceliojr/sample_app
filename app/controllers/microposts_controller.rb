class MicropostsController < ApplicationController
  before_action :signed_in_user
  before_action :current_user, only: [:create, :destroy]

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      render 'static_pages/home'
    end
  end
  
  def destroy
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content)
  end

  def correct_user
      @user = User.find(params[:id])
      unless current_user?(@user)
        flash[:error] = "Usuário não tem permissão para executar essa ação."
        redirect_to root_url
      end
    end
end