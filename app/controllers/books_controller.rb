class BooksController < ApplicationController
  def index
    @book = Book.new  # indexページでのCSS切り替え用
    @books = Book.all
  end

  def show
    @book = Book.find(params[:id])
  end

  def edit
    @book = Book.find(params[:id])
  end

  def create
    @book = Book.new(book_params)
    if @book.save
      flash[:success] = "Book was successfully created."
      redirect_to book_path(@book.id)
    else
      flash_with_error
      @books = Book.all
      render :index,  status: :unprocessable_entity
    end
  end

  def destroy
    book = Book.find(params[:id])
    if book.destroy
      flash[:success_destroy] = "Book was successfully destroyed."
    else
      flash[:error_destroy] = "There are some errors in destroying the book. Please retry."
    end
    redirect_to books_path
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      flash[:success] = "Book was successfully updated."
      redirect_to book_path(@book.id)
    else
      flash_with_error
      render :edit, status: :unprocessable_entity  # turboに適切なステータスコードを渡す
    end
  end

  private
    def book_params
      params.require(:book).permit(:title, :body)
    end
    
    def flash_with_error
      flash.now[:alert] = "#{@book.errors.count} error".pluralize + " prohibited this book from begin saved:"
      flash.now[:error_messages] = @book.errors.full_messages
    end
end
