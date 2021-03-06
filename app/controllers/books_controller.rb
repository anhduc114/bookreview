class BooksController < ApplicationController
    before_action :find_book, only: [:show, :edit, :update, :destroy]
    # kiem tra user trc khi tao hay edit book
    before_action :authenticate_user!, only: [:new, :edit]
    
    def index
        if params[:category].blank?
        @books = Book.all.order("created_at DESC")
    else
        # sort and show books with perspective id
        @category_id = Category.find_by(name: params[:category]).id
        @books = Book.where(:category_id => @category_id).order("created_at DESC")
        end
    end
 
    def show
        if @book.reviews.blank?
            @avarage_review = 0
            else
                @avarage_review = @book.reviews.avarage(:rating).round(2)
        end
    end
    
    def new
        #  @book = Book.new
        @book = current_user.books.build     # use this so we can add book using current user
        @categories =  Category.all.map{ |c| [c.name,c.id]}
    end
    
    def create
        # @book = Book.new(books_params)
        @book = current_user.books.build(books_params)
        @book.category_id = params[:category_id]
        if @book.save 
            redirect_to root_path
        else
            render 'new'
        end
    end
    
    def edit
        @categories =  Category.all.map{ |c| [c.name,c.id]}
    end
    
    def update
        @book.category_id = params[:category_id]
        if @book.update(books_params)
            redirect_to book_path(@book)
        else
            render 'edit'
        end
    end
    
    def destroy
        @book.destroy
        redirect_to root_path
    end
    
    private
    
    def books_params
         params.require(:book).permit(:title, :description, :author, :category, :book_img) 
    end
    
    def find_book
            @book = Book.find(params[:id])
    end
end
