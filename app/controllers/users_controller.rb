# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    @users = User.order(:id).page(params[:page])
  end

  def show
    @user = User.find(params[:id])
    set_user
  end

  private

  def user_params
    params.require(:user).permit(:name, :post_number, :address, :self_introduction)
  end
end
