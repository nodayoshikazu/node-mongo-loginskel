#
# users.coffee
#
#  users collection has only email and password 
#   { "_id" : ObjectId("518b37d647f1af1b31be73f4"), "email" : "test255@gmail.com", "password" : "password" }
#
mongodb = require 'mongodb'
dbconnection = require './dbconnection'
should = require('should')


module.exports = class Users extends dbconnection

    #
    # Constructor
    # 
    constructor: ->
        super()

    #
    # Looks up a user data from email (username)
    # 
    findByEmail: (obj, fn) ->
        #console.log obj
        client = dbconnection.get_client()
        client.open (err, p_client) =>
            client.collection 'users', (err, col) =>
                if err
                    console.log(err)
                    client.close()
                    return fn(err, null)
                col.findOne {"email": obj.username}, (err, user) =>
                    client.close()
                    fn(err, user)

    #
    # Checks if password matches the user.password
    # 
    verifyPassword: (user, password) ->
        user.password is password

    #
    # Get all users - mongodb.find() example only
    # 
    findAll: (fn) ->
        client = dbconnection.get_client()
        client.open (err, p_client) =>
            client.collection 'users', (err, col) =>
                if err
                    console.log(err)
                    client.close()                    
                    return fn(err, null)
                col.find {}, (err, cursor) =>
                    if err
                        console.log(err)
                        client.close()
                        return fn(err, null)                        
                    cursor.toArray (err, items) =>
                        items.length.should.be.above(0)
                        client.close()
                        fn(err, items)

               