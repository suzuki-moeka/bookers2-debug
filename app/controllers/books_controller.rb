class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_current_user, only: [:edit, :update]

  def show
    @books = Book.all
    @book = Book.find(params[:id])
     unless ViewCount.find_by(user_id: current_user.id, book_id: @book.id)
       current_user.view_counts.create(book_id: @book.id)
     end
    @book_new = Book.new
    @user = @book.user
    @book_comment = BookComment.new
  end


  def index
    to  = Time.current.at_beginning_of_day
    from  = (to - 6.day).at_end_of_day
    @books = Book.all.sort {|a,b|
      b.favorites.where(created_at: from...to).size <=>
      a.favorites.where(created_at: from...to).size
    }
    @book = Book.new
  end

  def create
    @books = Book.all
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book.id), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def ensure_current_user
    @book = Book.find(params[:id])
    @user = @book.user
    redirect_to(books_path) unless @user == current_user
  end

end