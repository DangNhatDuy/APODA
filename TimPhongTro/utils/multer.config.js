let multer = require('multer');
let path = require('path');

const PATH_STORAGE_IMAGE = path.resolve(__dirname ,'../public');

var storage = multer.diskStorage({
    destination: function (req, file, cb) {
      cb(null, PATH_STORAGE_IMAGE);
    },
    filename: function (req, file, cb) {
        console.log(req.headers['user-id']);
        console.log(req);
        //cb(null, `${imageName[i]}_${file.originalname}`);
        cb(null, `${file.originalname}`);
    } 
  });
let fileFilter = (req, file ,cb) =>{
  
  let {mimetype} = file;

  if(mimetype == 'image/jpeg' || mimetype =='image/png'){
    cb(null, true);
  }
  else{
    cb(new Error('lỗi không đúng định dạng file'));
  }
};

var upload = multer({ storage: storage ,fileFilter});

module.exports = upload;