class Api::BooksController < ApiController
   
    def create
        book = Book.new(book_params)
        if book.save
            render json: book
        else
            render json: { errors: book.errors.full_messages }, status: :unprocessable_entity 
        end
    end 
    
    private
    
    def book_params
        params.require(:book).permit(:title, categoryCodes: [])
    end
end