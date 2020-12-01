const nodemailer = require('nodemailer');
const EMAIL = 'nhatro.apoda@gmail.com';
const PASS_EMAIL = 'Nh@tduy1103';

const sendMail = (Email,planText) =>{
    return new Promise(resolve =>{
        var transporter =  nodemailer.createTransport({ // config mail server
            service: 'Gmail',
            auth: {
                user:  EMAIL,
                pass: PASS_EMAIL
            }
        });
        
        var mainOptions = { // thiết lập đối tượng, nội dung gửi mail
            from: 'APODA',
            to: Email,
            subject: 'APODA',
            text: 'APODA',
            html: planText
        }
        transporter.sendMail(mainOptions, function(err, info){
            if (err) {
                console.log(err);
                if(err) return resolve({err: true, message: err.message});
            } else {
                console.log('Message sent: ' +  info.response);
                
                return resolve({ err: false}); 
            }
        });
    });
};

exports.sendMail = sendMail;