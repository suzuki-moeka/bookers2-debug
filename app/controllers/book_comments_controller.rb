class BookCommentsController < ApplicationController
  def create
    book = Book.find(params[:book_id])
    @books = Book.find(params[:book_id])
    @book_comment = BookComment.new
    comment = current_user.book_comments.new(book_comment_params)
    comment.book_id = book.id
    comment.save
  end
   
  def destroy
    BookComment.find(params[:id]).destroy
    @books = Book.find(params[:book_id])
    @book_comment.destroy
    @book_comment = BookComment.new
  end

  private

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end
end
