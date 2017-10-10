class Api::CategoriesController < ApiController
   
    def create
        category = Category.new(cat_params)
        if category.superCategoryCode?
           parent = Category.find_by code:category.superCategoryCode
           category.parent_id = parent.id
        end
        if category.save
            render json: category
        else
            render json: { errors: category.errors.full_messages }, status: :unprocessable_entity
        end
    end
    
    private
    
    def cat_params
        params.require(:category).permit(:code, :title, :superCategoryCode)
    end
end