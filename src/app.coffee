#
# app.coffee
# 
# Node.js + Express + MongoDB RESTful app skeleton
#  with login API using passport.js
#  API users communicate by access token returned from POST /app/tokens
# 
express          = require("express")
_                = require("underscore")
fs               = require("fs")
dbconnection     = require("./models/dbconnection")
Users            = require("./models/users")
Tokens           = require("./models/tokens")
http             = require("http")
path             = require("path")
passport         = require("passport")
LocalStrategy    = require("passport-local").Strategy

users = new Users()

# Allow cross domain for all api
allowCrossDomain = (req, res, next) ->
    res.header 'Access-Control-Allow-Origin', '*'
    res.header 'Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE,OPTIONS'
    res.header 'Access-Control-Allow-Headers', 'Content-Type'
    if req.method is 'OPTIONS'
        res.send 200
    else
        next()

# Auth by username(email) and password
passport.use(new LocalStrategy(  (username, password, done) ->
    process.nextTick ->
        users.findByEmail {username: username}, (err, user) ->
            if err
                return done(err)
            unless user
                return done(null, false, message: "Unknown user " + username)   # don't ever 'return' keyword!
            unless users.verifyPassword(user, password)
                return done(null, false, message: "Invalid password")   # don't ever 'return' keyword!
            done null, user
))

app = express()
app.configure ->
    app.set "port", process.env.PORT or 3000
    app.use express.favicon()
    app.use express.logger("dev")
    app.use express.bodyParser()
    app.use express.methodOverride()
    app.use allowCrossDomain
    app.use passport.initialize()
    app.use app.router
    app.use express.static(path.join(__dirname, "public"))

app.configure "development", ->
    app.use express.errorHandler()

# Sample
app.get "/app/users", (req, res) ->
    users.findAll (err, all) ->
        res.status 200
        res.json all

# Login - post username and password
app.post "/app/tokens", (req, res, next) ->
    passport.authenticate("local", {session: false}, (err, user, info) =>
        if err
            return next(err)
        if not user
            res.status 404
            return res.send null
        else
            tokens = new Tokens()
            tokens.create user, (err, tk) =>
                res.status 200
                return res.send tk
    )(req, res, next)

#
# Always include the obtained access token for all API after login
# Logout - post token
#
app.delete "/app/tokens", (req, res) ->
    tokens = new Tokens()
    #
    # This is how you validate the access token.
    #  If ok is not null, it has been validated, and ok is null otherwise.
    # 
    tokens.validate req.body.token, (err, ok) =>
        if err
            res.status 401
            res.send "Invalid token or token had expired"
        else
            if ok is null
                res.status 401
                res.send "Invalid token or token had expired"
            else
                tokens.delete req.body.token, (err, wtf)->
                    if err
                        res.status err
                        res.send wtf
                    else
                        res.status 200
                        res.send "You have signed out"

# Login Form
app.get "/app/login", (req, res) ->
    login_form = '<form action="/app/tokens" method="post">'+
        '<div><label>Email:</label><input type="text" name="username"/></div>'+
        '<div><label>Password:</label><input type="password" name="password"/></div>'+
        '<div><input type="submit" value="Login"/></div></form>'
    res.status 200
    res.send (login_form)

# Logout form
app.get "/app/logout", (req, res) ->
    logout_form = '<form action="/app/tokens" method="post">'+
        '    <div><label for="token">Token:</label><input type="text" name="token" id="token" /></div>'+
        '    <input type="submit" value="Logout"/>' +
        '    <input type="hidden" id="_method" name="_method" value="delete" />' +
        '</form>'
    res.status 200
    res.send (logout_form)    
  

#
# Server with Cluster
# 
server = http.createServer(app)
server.listen(app.get('port'))
