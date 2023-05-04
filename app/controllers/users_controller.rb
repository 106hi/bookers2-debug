class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
    @today_book = @books.created_today
    @yesterday_book = @books.created_yesterday
    @two_days_ago_book = @books.created_2_days_ago
    @three_days_ago_book = @books.created_3_days_ago
    @four_days_ago_book = @books.created_4_days_ago
    @five_days_ago_book = @books.created_5_days_ago
    @six_days_ago_book = @books.created_6_days_ago
    @this_week_book = @books.created_this_week
    @last_week_book = @books.created_last_week
    to = Time.current.at_end_of_day
    from = (to - 6.day).at_beginning_of_day
    @rank_books = Book.includes(:favorited_users).
      sort {|a,b|
        b.favorited_users.includes(:favorites).where(created_at: from...to).size <=>
        a.favorited_users.includes(:favorites).where(created_at: from...to).size
      }
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render "edit"
    end
  end

  def search
    @user = User.find(params[:user_id])
    if params[:created_at] == ""
      @books = "日付が選択されていません"
    else
      @books = @user.books.where(created_at: params[:created_at].to_date.all_day).count
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
