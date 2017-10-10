class Api::NewslettersController < ApiController
   
   def index
       newsletters = Newsletter.all
       render json: newsletters, each_serializer: NewsletterSerializer
   end
    
end