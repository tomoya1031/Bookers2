class BooksController < ApplicationController
    before_action :authenticate_user!
  def index
    @books = Book.page(params[:page]).reverse_order
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      flash[:notice] = "Book was successfully created."
      redirect_to books_path
    else
      @books = Book.all
      render action: :index
    end
  end

  def show
    @book = Book.find(params[:id])
    @new_book = Book.new
  end

  def edit
    @book = Book.find(params[:id])
  end

  def destroy
    book = Book.find(params[:id])
    if book.destroy
      flash[:notice] = "Book was successfully destroy."
      redirect_to books_path
    else
      render action: :index
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      flash[:notice] = "Book was successfully update."
      redirect_to book_path(@book)
    else
      render action: :edit
    end
  end

  private
  def book_params
    params.require(:book).permit(:title, :body)
  end
end