class BooksController < ApplicationController
    before_action :find_book, only: [:show, :edit, :update, :destroy]
    
    def index
        @books = Book.all.order("created_at DESC")
    end
    
    def show

    end
    
    def new
        #  @book = Book.new
        @book = current_user.books.build     # use this so we can add book using current user
        @categories =  Category.all.map{ |c| [c.name,c.id]}
    end
    
    def create
        # @book = Book.new(books_params)
        @book = current_user.books.build(books_params)
        
        if @book.save
            redirect_to root_path
        else
            render 'new'
        end
    end
    
    def edit
    end
    
    def update
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
         params.require(:book).permit(:title, :description, :author) 
    end
    
    def find_book
            @book = Book.find(params[:id])
    end
end
