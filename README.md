


## First Steps

1. Install Rails version 4.2.6

2. Clone the repository into your local environment.

3. Go to the app directory newsletter-service in your command line or console

4. Migrate the database using the following command

    `rake db:migrate`

5. Run the rails server 
 

    `rails s`
    
    you should see the following message
    
    `Rails 4.2.6 application starting in development on http://0.0.0:8080`

6. Open a second command line or console, and go to the app "newsletter-service"

## How to use the API Service

1. While the Rails server is running, go to the second command line or console with the path pointing to your app "newsletter-service"

2. Create your Categories first, as they are the basis for creating and associating the other objects

        `curl -d "category[code]=NUR" -d "category[title]=Nursing" -d "category[superCategoryCode]="  https://newsletter-service-amin.herokuapp.com/api/categories`


        `curl -d "category[code]=PALL" -d "category[title]=Palliative Care" -d "category[superCategoryCode]=NUR"  https://newsletter-service-amin.herokuapp.com/api/categories`


3. Next create your Books, as they are the basis for the Subscriber Newsletters


        `curl -d "book[title]=About Palliative Care" -d "book[categoryCodes][]=PALL"  https://newsletter-service-amin.herokuapp.com/api/books`




4. Now create your Subscribers.  Every time a Subscriber is created, a Newsletter with Book Notifications will be created.  

 
        `curl -d "subscriber[email]=email addresss" -d "subscriber[categoryCodes][]=PALL"  https://newsletter-service-amin.herokuapp.com/api/subscribers`


OR


        `curl -d "subscriber[email]=email addresss" -d "subscriber[categoryCodes][]=PALL" -d "subscriber[categoryCodes][]=*other code for category already created" https://newsletter-service-amin.herokuapp.com/api/subscribers`
        Response
        `{"id":98,"email":"email addresss","created_at":"2017-10-10T13:01:51.284Z","updated_at":"2017-10-10T13:01:51.284Z","categoryCodes":["PALL","*other code"]}`


5. At this point you will have created all the data necessary for obtaining newsletters


        `curl https://newsletter-service-amin.herokuapp.com/api/subscribers/newsletters`



















