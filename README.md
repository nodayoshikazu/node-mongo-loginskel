#node-mongo-loginskel

A Node.js and Express app skeleton with only login/logout API. This is a platform to start building a Node.js RESTful app. This app uses mongodb for the persistent storage, Passport.js for authentication and source code is written in Coffeescript. I wrote this because I wanted to learn how to use MongoDB. This should be a good example if you were new to MongoDB just like I was.


#Installation
 
    > make init
    > make build

#Document

Prerequisite

MongoDB

In order for this app to work without any customization, you will need to prepare a few mongodb contents.

Please create a Mongo DB "node-mongo-loginskel." Then create a collection "users." Necessary fields for the users collection are "email" and "password." Also you need to have "tokens" collection to store and manage "access token." The "tokens" collection consists of document with fields "token", "user_id" and "expire." Please refer to src/models/users.coffee and tokens.coffee for the details.


#API

Currently there are only 4 APIs in this app.

GET /app/login   returns login form html
GET /app/logout  returns logout form html

POST /app/tokens  create an access token and returns it = login
DELETE /app/tokens  remove the arg token = logout



#License 

(The MIT License)

Copyright (c) 2013 Noda Yoshikazu &lt;noda.yoshikazu@gmail.com&gt;

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
