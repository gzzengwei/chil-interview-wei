# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[ show ]

  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    registration_service = Users::Registration.new(user_params)

    if registration_service.register
      @user = registration_service.user
      redirect_to @user, notice: "User was successfully created."
    else
      @user = registration_service.user
      render :new, status: :unprocessable_entity
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :referral_code)
    end
end
