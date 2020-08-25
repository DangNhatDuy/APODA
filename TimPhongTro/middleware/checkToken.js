const {verifyPromise} = require('./../utils/jwt');
const verifyToken = async (req, res, next) =>{
    
        let token = req.headers['access-token'] || req.body.token || req.query.token;
        let id = req.headers['user-id'];
        
        if(token){
            try {
                let decoded = await verifyPromise(token);

                if(decoded.error){
                    return res.json({status: false, message: 'TOKEN_FAIL'});
                }
                else{
                    let iduser = decoded.data.id;

                    if(id != iduser){
                        return res.json({status: false, message: 'User ID không khớp!'});
                    }
                    
                    req.decoded = decoded;
                    next();
                }

            } catch (err) {
                return res.json({status: false, message:err.message});
            }
        }
        else {
            return res.json({status: false, message: 'TOKEN_FAIL'});
        }
};

exports.verifyToken = verifyToken;