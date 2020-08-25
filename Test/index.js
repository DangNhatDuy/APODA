const express = require('express');
const app = express();

app.get('/', (req, res)=>{
    return res.json('Hello');
})

app.listen(3000,(err)=>{
    console.log('app run on port 3000');
    
})