## How to use the API Service

1. Create your Categories first, as they are the basis for creating and associating the other objects

        `curl -d "category[code]=NUR" -d "category[title]=Nursing" -d "category[superCategoryCode]="  https://newsletter-service-amin.herokuapp.com/api/categories`


        `curl -d "category[code]=PALL" -d "category[title]=Palliative Care" -d "category[superCategoryCode]=NUR"  https://newsletter-service-amin.herokuapp.com/api/categories`


2. Next create your Books, as they are the basis for the Subscriber Newsletters


        `curl -d "book[title]=About Palliative Care" -d "book[categoryCodes][]=PALL"  https://newsletter-service-amin.herokuapp.com/api/books`




3. Now create your Subscribers.  Every time a Subscriber is created, a Newsletter with Book Notifications will be created.  

 
        `curl -d "subscriber[email]=email addresss" -d "subscriber[categoryCodes][]=PALL"  https://newsletter-service-amin.herokuapp.com/api/subscribers`


        OR


        `curl -d "subscriber[email]=email addresss" -d "subscriber[categoryCodes][]=PALL" -d "subscriber[categoryCodes][]=*other code for category already created" https://newsletter-service-amin.herokuapp.com/api/subscribers`
        Response
        `{"id":98,"email":"email addresss","created_at":"2017-10-10T13:01:51.284Z","updated_at":"2017-10-10T13:01:51.284Z","categoryCodes":["PALL","*other code"]}`


4. At this point you will have created all the data necessary for obtaining newsletters


        `curl https://newsletter-service-amin.herokuapp.com/api/newsletters`



















