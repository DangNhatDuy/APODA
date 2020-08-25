const log = require('log4js').getLogger();

const roleStaff =  (req, res, next) =>{
    
    let infoUser = req.decoded.data;

    let {Role} = infoUser;
    
    if(!infoUser){
        return res.json({error: true, message: 'Account '+ __('NOT_VALID')});
    }
    else
    {
        if( Role.trim() == "Staff" || Role.trim() == 'Admin'){
            log.info('Verify role staff success: ',{infoUser});
            next();
        }
        else{
            log.error('Verify role staff: ', __('Err_Role'));
            return res.json({error: true, message: __('Err_Role')});
        }
    }
}

exports.roleStaff = roleStaff;