const express = require('express');
const app = express();
const bodyParser = require('body-parser');

//ROUTE
const {USER_ROUTER} = require('./router/user');
const {HOME_ROUTER} = require('./router/home');
const {ROOM_ROUTER} = require('./router/room');
const {LOCATION_ROUTER} = require('./router/location');

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended: true}));
app.use('/user', USER_ROUTER);
app.use('/home', HOME_ROUTER);
app.use('/image', express.static(__dirname + "/public"));
app.use('/room', ROOM_ROUTER);
app.use('/location', LOCATION_ROUTER);


app.get('/', (req, res) =>{
    return res.json('Nhat Duy');
})

app.listen(3000, (err) => {
    if(err) console.log('Server is not start', err);
    else console.log('Server start at port 3000');
})