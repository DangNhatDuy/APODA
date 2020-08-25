const random  = require('random');

const codeNumber = () =>{
    let txtString = '';
    for(i = 0; i < 6; i++){
        let value = random.int(min =0, max =9);
        txtString = txtString +value;
    }
    console.log(txtString);
    return txtString;
}

module.exports = {
    codeNumber
}