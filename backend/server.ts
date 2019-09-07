import express from 'express';
const passport = require('passport');
const GoogleStrategy = require('passport-google-oauth20').Strategy;

const { port } = require('../config/env');
const { clientID, clientSecret } = require('../config/auth');

passport.use(new GoogleStrategy(
    {
        clientID: clientID,
        clientSecret: clientSecret,
        callbackURL: 'http://localhost:8080/auth/google/callback',
    },
    (accessToken) => {
        console.log(accessToken);
    }
));

const app = express();

app.get('/', (req, res) => {
    res.end('Hello world!');
});

app.get('/auth/google', passport.authenticate('google', { scope: ['profile'] }));

app.get('/auth/google/callback', passport.authenticate('google'));

app.listen(port, () => console.log(`Listening on port ${port}`));
