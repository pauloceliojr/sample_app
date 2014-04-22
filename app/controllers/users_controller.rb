class UsersController < ApplicationController
  before_action :new_user, only: [:new, :create]
  before_action :signed_in_user, only: [:index, :edit, :update]
  before_action :correct_user, only: [:edit, :update]

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # Before filters

    def new_user
      if signed_in?
        flash[:error] = "Acesso permitido apenas para novos usuários."
        redirect_to root_url
      end
    end

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end

    def correct_user
      @user = User.find(params[:id])
      unless current_user?(@user)
        flash[:error] = "Usuário não tem permissão"
        redirect_to root_url
      end
    end

end