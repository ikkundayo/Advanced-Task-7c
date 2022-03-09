class BooksController < ApplicationController

  def show
    @book = Book.new
    @books = Book.find(params[:id])
    @user = @books.user
    @book_comment = Bookcomment.new
    
  end

  def index
    @book = Book.new
    if params[:button].to_i == 1
      @books= Book.all.order(created_at: :desc)
    elsif params[:button].to_i == 2
      @books= Book.all.order(star: :desc)
    else
      @books = Book.all
      if params[:tag_name]
        @books = Book.tagged_with("#{params[:tag_name]}")
      end
    end
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
    if @book.user == current_user
      render :edit
    else
      redirect_to books_path
    end
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
    params.require(:book).permit(:title, :body, :star, :tag_list)
  end
end
