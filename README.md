Orderomat App
===
About
---
This app is intended solely for testing purposes. 
However, if that does not discourage you 
and you still want to waste your time running it 
and testing its poorly implemented and occasionally 
rather illogical functionalities, we suggest you read
this amusing manual first.

Prerequisities
---
- Ruby version 2.4 (I think)
- Postgresql database (get used to it)
- Rails (what did you expect?)

Additionally, you may need database access. To avoid
ending up like a <i>balrog</i> fighting the mighty wizard Gandalf,
add your database username and password into your locales
so that, unlike me, you avoid publishing your credentials on GitHub
for all the world to see. (Refer to config/database.yml for further 
details.)

How to use this app (and survive)
---
This app simulates a system enabling companies to send 
(mostly meaningless and non-profit) orders (seriously, three axes??) 
to other companies. As a company (which you prove by providing
an access_token in any request header) you can:

- list all companies:<br>
GET "/companies"
- view company detail<br>
GET "/companies/:id" where <i>:id</i> is generally acquired in the list mentioned
above (don't tell me you skipped some text!)
- view what you have ordered<br>
GET "/orders/as_customer/(:status)" where <i>:status</i> is optional
when you want to list only orders which are
    - created (created)
    - in process (in_process)
    - sent out (sent_out)
    - accepted by the customer (accepted)
- view what others have ordered from you<br>
GET "/orders/as_provider/(:status)" where <i>:status</i> is... oh, who am
I kidding, either you are being deadly serious with the intention of using this app, in which case you have read the
previous bullet point and know the status option better than anyone
or you are not even reading this (much more likely, frankly).
- view an order that you commission / provide<br>
GET "/orders/:id" where <i>:id</i> can be acquired in the list of orders above

- commission a new order<br>
POST "/orders"; you need to provide "provider_id", "description" and 
"deadline" (in the ISO timestamp format) in the request body

- edit the status of an order which you commission / provide<br>
PUT "/orders/:id" oh, do not let me repeat myself on the topic of the 
aforementioned <i>:id</i> for I would much rather just tell you that
the only status you can set up for an order is "accepted" (if you are a customer)
or "in_process" or "sent_out" (if you are a provider). No other changes 
are allowed. That is business, by the way.

Despite my vivid imagination I cannot conjure up what else you would 
ever want to do with such a good-for-nothing app; at this point I suspect 
that you cloned the app repository just to have a laugh about this
 manual. Stop laughing. Stop it. <b>STOP IT NOW!!!</b>
 
 Oh, and by the way, this service is available at https://thawing-depths-99972.herokuapp.com/
 and you can find the made up companies along with their slightly ridiculous
orders in the "db/migrate/seeds.rb" file along with some useful access tokens
 and other strictly private data.