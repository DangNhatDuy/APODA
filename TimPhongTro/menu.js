const { Pool } = require("pg");
const {DATABASE_NAME, DATABASE_PWD, SCHEMAS} = require('./const.js');

const pool = new Pool({
  user: "postgres",
  host: "localhost",
  database: DATABASE_NAME,
  password: DATABASE_PWD,
  port: "5432"
});

function getfunc(key, bindParams){
    switch(key) {
        
        case 'LOGIN':{
            let nameFunc = 'func_login';

            let cmd = getQuery(nameFunc, bindParams);
            
            console.log(cmd);
            return cmd;
        }
        case 'USER':{
            let nameFunc = 'prc_process_user_info';

            let cmd = getQuery(nameFunc, bindParams);

            console.log(cmd);
            
            return cmd;
        }
        case 'USER_INFO':{
            let nameFunc = 'function_get_user_info';

            let cmd = getQuery(nameFunc, bindParams);

            console.log(cmd);
            
            return cmd;
        }
        case 'GET_PASSWORD':{
            let nameFunc = 'func_get_password';

            let cmd = getQuery(nameFunc, bindParams);

            console.log(cmd);
            
            return cmd;
        }
        case 'CHANGE_PASSWORD':{
            let nameFunc = 'func_change_password';

            let cmd = getQuery(nameFunc, bindParams);

            console.log(cmd);
            
            return cmd;
        }
        case 'HOME_RESERVATION':{
            let nameFunc = 'function_get_home_from_reservation';

            let cmd = getQuery(nameFunc, bindParams);

            console.log(cmd);
            
            return cmd;
        }
        case 'ROOM_RESERVATION':{
            let nameFunc = 'function_get_room_from_reservation';

            let cmd = getQuery(nameFunc, bindParams);

            console.log(cmd);
            
            return cmd;
        }
        case 'MY_HOME':{
            let nameFunc = 'function_get_host_home';

            let cmd = getQuery(nameFunc, bindParams);

            console.log(cmd);
            
            return cmd;
        }
        case 'LIST_USER':{
            let nameFunc = 'view_list_user';

            let cmd = getQuery(nameFunc, bindParams);

            console.log(cmd);
            
            return cmd;
        }
        case 'HOME':{
            let nameFunc = 'prc_process_home_info';

            let cmd = getQuery(nameFunc, bindParams);

            console.log(cmd);
            
            return cmd;
        }
        case 'LIST_HOME':{
            let nameFunc = 'view_list_home';

            let cmd = getQuery(nameFunc, bindParams);

            console.log(cmd);
            
            return cmd;
        }
        case 'LIST_HOME_ACTIVE':{
            let nameFunc = 'view_list_home_active';

            let cmd = getQuery(nameFunc, bindParams);

            console.log(cmd);
            
            return cmd;
        }
        case 'VERIFY_HOME':{
            let nameFunc = 'func_verify_home';

            let cmd = getQuery(nameFunc, bindParams);

            console.log(cmd);
            
            return cmd;
        }
        case 'HOME_DETAIL':{
            let nameFunc = 'function_get_home_detail';

            let cmd = getQuery(nameFunc, bindParams);

            console.log(cmd);
            
            return cmd;
        }
        case 'HOME_RATING':{
            let nameFunc = 'function_get_home_rating';

            let cmd = getQuery(nameFunc, bindParams);

            console.log(cmd);
            
            return cmd;
        }
        case 'RATING':{
            let nameFunc = 'prc_process_rating_info';

            let cmd = getQuery(nameFunc, bindParams);

            console.log(cmd);
            
            return cmd;
        }
        case 'SEARCH':{
            let nameFunc = 'function_search_home';

            let cmd = getQuery(nameFunc, bindParams);

            console.log(cmd);
            
            return cmd;
        }
        case 'LIST_ROOM':{
            let nameFunc = 'function_get_list_room';

            let cmd = getQuery(nameFunc, bindParams);

            console.log(cmd);
            
            return cmd;
        }
        case 'ROOM':{
            let nameFunc = 'prc_process_room_info';

            let cmd = getQuery(nameFunc, bindParams);

            console.log(cmd);
            
            return cmd;
        }
        case 'ROOM_DETAIL':{
            let nameFunc = 'function_get_room_detail';

            let cmd = getQuery(nameFunc, bindParams);

            console.log(cmd);
            
            return cmd;
        }
        case 'ROOM_STATUS':{
            let nameFunc = 'func_update_room_status';

            let cmd = getQuery(nameFunc, bindParams);

            console.log(cmd);
            
            return cmd;
        }
        case 'RESERVATION':{
            let nameFunc = 'prc_process_reservation_info';

            let cmd = getQuery(nameFunc, bindParams);

            console.log(cmd);
            
            return cmd;
        }
        case 'RESERVATION_INFO':{
            let nameFunc = 'function_get_reservation_info';

            let cmd = getQuery(nameFunc, bindParams);

            console.log(cmd);
            
            return cmd;
        }
        case 'CITY':{
            let nameFunc = 'v_list_city';

            let cmd = getQuery(nameFunc, bindParams);

            console.log(cmd);
            
            return cmd;
        }
        case 'DISTRICT':{
            let nameFunc = 'v_list_district';

            let cmd = getQuery(nameFunc, bindParams);

            console.log(cmd);
            
            return cmd;
        }
        case 'WARD':{
            let nameFunc = 'v_list_ward';

            let cmd = getQuery(nameFunc, bindParams);

            console.log(cmd);
            
            return cmd;
        }
        case 'CHECK_EMAIL':{
            let nameFunc = 'func_forget_password';

            let cmd = getQuery(nameFunc, bindParams);
            
            return cmd;
        }
        
        default: return;
    }
}

// ham lay cau lenh query vao database
function getQuery(nameFunc, bindParams){
    let query = 'SELECT * FROM '+ nameFunc + "(";
    let str;

    if(bindParams.length == 0){
        query = 'SELECT * FROM '+ nameFunc;
        return query;
    } 
    else{
        bindParams.forEach(item => {                             
            query = `${query}'${item.toString().trim()}',`;
        });
    }  
    str = query.slice(0,[query.length-1]) + ")";  
    console.log({str});
    return str;
}


/**
 * 
 * @param {*} key  chuc nang tu client
 * @param {*} bindParams voi bindParams la 1 object danh sach cac tham so bindParams {username, .... }
 */

async function exequery(key, bindParams){
     return new Promise(async resolve =>{
        const client = await pool
        .connect()

        .catch(err => {
        console.log("\nclient.connect():", err.name);

        // iterate over the error object attributes
        for (item in err) {
            if (err[item] != undefined) {
            process.stdout.write(item + " - " + err[item] + " ");
            }
        }

        // end the Pool instance
        console.log("\n");
        process.exit();
        });

    try {
        // Initiate the Postgres transaction
        await client.query("BEGIN");

        try {
            await client.query(`SET search_path TO "${SCHEMAS}"`)
            .then(async function (res) {             
                
                // Ham goi lay chuoi query vao database
                let func = getfunc(key, bindParams); 

                // Pass SQL string to the query() method
                await client.query(func, function(err, result) {                 
                    
                    if (err) {
                        // Rollback before executing another transaction
                        client.query("ROLLBACK");
                        console.log("Transaction ROLLBACK called");                        

                        return resolve({error: true, message: err.message});
                    } else {

                    client.query("COMMIT");                    

                    return resolve({error: false, result});
                    }
                });
            });
            
        } catch (er) {
            // Rollback before executing another transaction
            client.query("ROLLBACK");
           
            console.log("Transaction ROLLBACK called");

            return resolve({error: true, message: er.message});
        }
    } finally {
        client.release();
        console.log("Client is released");
    }

   });
    
}


module.exports = {
    getfunc,
    exequery
}