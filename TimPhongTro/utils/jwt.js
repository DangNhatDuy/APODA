const jwt = require('jsonwebtoken');

const {KEY} = require('./../const');



const signPromise = objData => {
    return new Promise(resolve =>{
        try {
            jwt.sign(objData, KEY, {
                expiresIn: '1d'}, (err, token) => {
                if(err)  resolve({error: true, message: err.message});

                resolve({error: false, token: token});
              });
        } catch (error) {
            return resolve({error: true, message: error.message});
        }
    })
}

const verifyPromise = token => {
    return new Promise(resolve =>{
        try {
            jwt.verify(token, KEY, (err, data) =>{
                if(err)  resolve({error: true, message: err.message});

                resolve({error: false, data: data});
              });            
        } catch (error) {
            return resolve({error: true, message: error.message});
        }
    })
}

module.exports = {
    signPromise: signPromise,
    verifyPromise: verifyPromise
};