class Api::SubscribersController < ApiController
   
    def create
        subscriber = Subscriber.new(subs_params)
        if subscriber.save
            render json: subscriber   
        else 
            render json: { errors: subscriber.errors.full_messages }, status: :unprocessable_entity 
        end
    end
    
    def subs_params
        params.require(:subscriber).permit(:email, categoryCodes: [])
    end
end