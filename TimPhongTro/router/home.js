const express = require('express');
const route = express.Router();
const {exequery} = require('./../menu');
const upload = require('./../utils/multer.config');
const {verifyToken} = require('./../middleware/checkToken');
const geolib = require('geolib');
const {sendMail} = require('./../utils/sendMail')

route.post('/upload', verifyToken, upload.array('image', 1), async (req, res) => {
    try {
        let imageName = req.files[0].filename;
        let {id} = req.decoded.data;
        let {title, description, address, lat, long, idward} = req.body;

        if(title == '' || title == undefined) {
            return res.json({
                status: false,
                message: 'Tiêu đề không được thiếu!'
            });
        }

        if(description == '' || description == undefined) {
            return res.json({
                status: false,
                message: 'Mô tả không được thiếu!'
            });
        }

        if(address == '' || address == undefined) {
            return res.json({
                status: false,
                message: 'Địa chỉ không được thiếu!'
            });
        }

        if(lat == '' || lat == undefined) {
            return res.json({
                status: false,
                message: 'Vĩ độ không được thiếu!'
            });
        }

        if(long == '' || long == undefined) {
            return res.json({
                status: false,
                message: 'Kinh độ không được thiếu!'
            });
        }

        if(idward == '' || idward == undefined) {
            return res.json({
                status: false,
                message: 'ID Phường không được thiếu!'
            });
        }

        if(imageName == '' || imageName == undefined) {
            return res.json({
                status: false,
                message: 'Hình ảnh không được thiếu!'
            });
        }

        let bindParams = [
            -1,
            title,
            description,
            address,
            imageName,
            id,
            lat,
            long,
            idward,
            'ADD'
        ];

        let {result} = await exequery('HOME', bindParams);

        if(result == undefined) {
            return res.json({
                status: false,
                message: 'Error'
            });
        }

        let {p_err_code, p_err_desc} = result.rows[0];

        if(p_err_code == 0) {
            return res.json({
                status: true,
                message: 'Thêm bài đăng thành công!'
            })
        }
        else {
            return res.json({
                status: false,
                message: p_err_desc
            })
        }
    } catch (error) {
        return res.json({
            status: false,
            message: error.message
        });
    }
})

route.post("/update", verifyToken, upload.array('image', 1), async (req, res) => {
    try {
        let imageName = req.files[0].filename;
        let {id, title, description, address, lat, long, idward} = req.body;

        if(id == '' || id == undefined) {
            return res.json({
                status: false,
                message: 'ID không được thiếu!'
            });
        }

        if(title == '' || title == undefined) {
            return res.json({
                status: false,
                message: 'Tiêu đề không được thiếu!'
            });
        }

        if(description == '' || description == undefined) {
            return res.json({
                status: false,
                message: 'Mô tả không được thiếu!'
            });
        }

        if(address == '' || address == undefined) {
            return res.json({
                status: false,
                message: 'Địa chỉ không được thiếu!'
            });
        }

        if(lat == '' || lat == undefined) {
            return res.json({
                status: false,
                message: 'Vĩ độ không được thiếu!'
            });
        }

        if(long == '' || long == undefined) {
            return res.json({
                status: false,
                message: 'Kinh độ không được thiếu!'
            });
        }

        if(idward == '' || idward == undefined) {
            return res.json({
                status: false,
                message: 'ID Phường không được thiếu!'
            });
        }

        if(imageName == '' || imageName == undefined) {
            return res.json({
                status: false,
                message: 'Hình ảnh không được thiếu!'
            });
        }

        let bindParams = [
            id,
            title,
            description,
            address,
            imageName,
            -1,
            lat,
            long,
            idward,
            'EDIT'
        ];

        let {result} = await exequery('HOME', bindParams);

        if(result == undefined) {
            return res.json({
                status: false,
                message: 'Error!'
            });
        }

        let {p_err_code, p_err_desc} = result.rows[0];

        if(p_err_code == 0) {
            return res.json({
                status: true,
                message: 'Sửa thông tin thành công!'
            });
        }
        else {
            return res.json({
                status: false,
                message: p_err_desc
            });
        }
    } catch (error) {
        return res.json({
            status: false,
            message: error.message
        });
    }
})

route.post("/delete", verifyToken, async (req, res) => {
    try {
        let {id} = req.body;

        if(id == '' || id == undefined) {
            return res.json({
                status: false,
                message: 'ID không được thiếu!'
            });
        }

        let bindParams = [
            id,
            '',
            '',
            '',
            '',
            -1,
            0.1,
            0.1,
            -1,
            'DEL'
        ];

        let {result} = await exequery('HOME', bindParams);

        if(result == undefined) {
            return res.json({
                status: false,
                message: 'Error'
            });
        }

        let {p_err_code, p_err_desc} = result.rows[0];

        if(p_err_code == 0) {
            return res.json({
                status: true,
                message: 'Xóa thành công!'
            });
        }
        else {
            return res.json({
                status: false,
                message: p_err_desc
            });
        }
    } catch (error) {
        return res.json({
            status: false,
            message: error.message
        });
    }
})

route.get('/active', async (req, res) => {
    try {
        let bindParams = [];
         
        let {result} = await exequery('LIST_HOME_ACTIVE', bindParams);

        if(result == undefined) {
            return res.json({
                status: false,
                message: 'Error'
            });
        }

        return res.json({
            status: true,
            message: '',
            data: result.rows
        })
    } catch (error) {
        return res.json({
            status: false,
            message: error.message
        });
    }
})

route.get('/', async (req, res) => {
    try {
        let bindParams = [];
         
        let {result} = await exequery('LIST_HOME', bindParams);

        if(result == undefined) {
            return res.json({
                status: false,
                message: 'Error'
            });
        }

        return res.json({
            status: true,
            message: '',
            data: result.rows
        })
    } catch (error) {
        return res.json({
            status: false,
            message: error.message
        });
    }
})

route.get('/reported', async (req, res) => {
    try {
        let bindParams = [];
         
        let {result} = await exequery('LIST_HOME_REPORTED', bindParams);

        if(result == undefined) {
            return res.json({
                status: false,
                message: 'Error'
            });
        }

        return res.json({
            status: true,
            message: '',
            data: result.rows
        })
    } catch (error) {
        return res.json({
            status: false,
            message: error.message
        });
    }
});

route.post('/favourite', verifyToken, async (req, res) => {
    try {
        let {id} = req.decoded.data;
        let bindParams = [
            id
        ];
         
        let {result} = await exequery('HOME_FAVOURITE', bindParams);

        if(result == undefined) {
            return res.json({
                status: false,
                message: 'Error'
            });
        }

        return res.json({
            status: true,
            message: '',
            data: result.rows
        })
    } catch (error) {
        return res.json({
            status: false,
            message: error.message
        });
    }
});

route.post('/verify', verifyToken, async (req, res) => {
    try {
        let {id, idward} = req.body;

        let {role} = req.decoded.data;

        if(parseInt(role) != 1) {
            return res.json({
                status: false,
                message: 'Chỉ có Admin mới có quyền verify bài viết này!'
            });
        }

        if(id == '' || id == undefined) {
            return res.json({
                status: false,
                message: 'ID không được thiếu!'
            });
        }

        let bindParams = [id];

        let {result} = await exequery('VERIFY_HOME', bindParams);

        if(result == undefined) {
            return res.json({
                status: false,
                message: 'Error'
            });
        }

        let {p_err_code, p_err_desc} = result.rows[0];

        if(p_err_code == 0) {
            bindParams = [idward];

            let resultGetEmail = await exequery('GET_EMAIL_USER', bindParams);
            
            if(resultGetEmail != undefined && resultGetEmail != null) {
                let listEmail = resultGetEmail.result.rows;
                let arrEmail = [];
                for (let index = 0; index < listEmail.length; index++) {
                    const element = listEmail[index];
                    arrEmail.push(element.email);
                }

                let body = '(Thông báo) Có 1 nhà trọ mới tại khu vực bạn quan tâm. Mở ứng dụng và kiểm tra liền nhé!';

                let resultSendMail = await sendMail(arrEmail, body);
            }

            return res.json({
                status: true,
                message: 'Verify bài đăng thành công!'
            });
        }
        else {
            return res.json({
                status: false,
                message: p_err_desc
            });
        }
    } catch (error) {
        return res.json({
            status: false,
            message: error.message
        });
    }
});

route.post('/unverify', verifyToken, async (req, res) => {
    try {
        let {id, reason} = req.body;

        let {role} = req.decoded.data;

        if(parseInt(role) != 1) {
            return res.json({
                status: false,
                message: 'Chỉ có Admin mới có quyền unverify bài viết này!'
            });
        }

        if(id == '' || id == undefined) {
            return res.json({
                status: false,
                message: 'ID không được thiếu!'
            });
        }

        if(reason == '' || reason == undefined) {
            return res.json({
                status: false,
                message: 'Lý do không được thiếu!'
            });
        }


        let bindParams = [id, reason];

        let {result} = await exequery('UNVERIFY_HOME', bindParams);

        if(result == undefined) {
            return res.json({
                status: false,
                message: 'Error'
            });
        }

        let {p_err_code, p_err_desc} = result.rows[0];

        if(p_err_code == 0) {
            return res.json({
                status: true,
                message: 'Hủy xác thực bài đăng thành công!'
            });
        }
        else {
            return res.json({
                status: false,
                message: p_err_desc
            });
        }
    } catch (error) {
        return res.json({
            status: false,
            message: error.message
        });
    }
});

route.post('/mail-host', verifyToken, async(req, res) =>{
    try {
        let {email} = req.body;

        if(email == '' || email == undefined) {
            return res.json({
                status: false,
                message: 'Email không được thiếu!'
            });
        }

        let body = '(Thông báo) Bạn có 1 bài đăng bị hủy xác thực. Mở ứng dụng và kiểm tra liền nhé!';

        let resultSendMail = await sendMail(email, body);
        return res.json({
            status: true,
            message: 'Thông báo đến chủ nhà thành công!'
        })
    } catch (error) {
        return res.json({
            status: false,
            message: error.message
        });
    }
});

route.post('/detail', async (req, res) => {
    try {
        let {id} = req.body;

        if(id == '' || id == undefined) {
            return res.json({
                status: false,
                message: 'ID không được thiếu!'
            });
        }

        let bindParams = [id];

        let {result} = await exequery('HOME_DETAIL', bindParams);

        if(result == undefined) {
            return res.json({
                status: false,
                message: 'Error'
            });
        }

        return res.json({
            status: true,
            message: '',
            data: result.rows[0]
        });
    } catch (error) {
        return res.json({
            status: false,
            message: error.message
        });
    }
});

route.post('/rating', verifyToken, async (req, res) => {
    try {
        let {id} = req.decoded.data;
        let {idhome, point, comment} = req.body;

        if(idhome == '' || idhome == undefined) {
            return res.json({
                status: false,
                message: 'ID không được thiếu!'
            });
        }

        if(point == '' || point == undefined) {
            return res.json({
                status: false,
                message: 'Điểm không được thiếu!'
            });
        }

        if(comment == '' || comment == undefined) {
            comment = '';
        }

        let bindParams = [
            id,
            idhome,
            point,
            comment,
            'ADD'
        ];

        let {result} = await exequery('RATING', bindParams);

        if(result == undefined) {
            return res.json({
                status: false,
                message: 'Error!'
            });
        }

        let {p_err_code, p_err_desc} = result.rows[0];

        if(p_err_code == 0) {
            return res.json({
                status: true,
                message: 'Đánh giá thành công!'
            });
        }
        else {
            return res.json({
                status: false,
                message: p_err_desc
            });
        }

    } catch (error) {
        return res.json({
            status: false,
            message: error.message
        });
    }
});

route.post('/rating/delete', verifyToken, async (req, res) => {
    try {
        let {id} = req.decoded.data;
        let {idhome} = req.body;

        if(idhome == '' || idhome == undefined) {
            return res.json({
                status: false,
                message: 'ID không được thiếu!'
            });
        }

        let bindParams = [
            id,
            idhome,
            0,
            '',
            'DEL'
        ];

        let {result} = await exequery('RATING', bindParams);

        if(result == undefined) {
            return res.json({
                status: false,
                message: 'Error!'
            });
        }

        let {p_err_code, p_err_desc} = result.rows[0];

        if(p_err_code == 0) {
            return res.json({
                status: true,
                message: 'Xóa đánh giá thành công!'
            });
        }
        else {
            return res.json({
                status: false,
                message: p_err_desc
            });
        }

    } catch (error) {
        return res.json({
            status: false,
            message: error.message
        });
    }
});

route.post('/list-rating', async (req, res) => {
    try {
        let {id} = req.body;

        if(id == '' || id == undefined) {
            return res.json({
                status: false,
                message: 'ID không được thiếu!'
            });
        }

        let bindParams = [id];

        let {result} = await exequery('HOME_RATING', bindParams);

        if(result == undefined) {
            return res.json({
                status: false,
                message: 'Error'
            });
        }

        return res.json({
            status: true,
            message: '',
            data: result.rows
        });
    } catch (error) {
        return res.json({
            status: false,
            message: error.message
        });
    }
});

route.post('/search', async (req, res) => {
    try {
        let {minprice, maxprice, minarea, maxarea, iddistrict, idward} = req.body;

        if(minprice == '' || minprice == undefined) {
            return res.json({
                status: false,
                message: 'Giá thấp nhất không được thiếu!'
            });
        }

        if(maxprice == '' || maxprice == undefined) {
            return res.json({
                status: false,
                message: 'Giá cao nhất không được thiếu!'
            });
        }

        if(minarea == '' || minarea == undefined) {
            return res.json({
                status: false,
                message: 'Diện tích thấp nhất không được thiếu!'
            });
        }

        if(iddistrict == '' || iddistrict == undefined) {
            return res.json({
                status: false,
                message: 'Mã phường không được thiếu!'
            });
        }

        if(maxarea == '' || maxarea == undefined) {
            return res.json({
                status: false,
                message: 'Diện tích cao nhất không được thiếu!'
            });
        }

        if(idward == '' || idward == undefined) {
            return res.json({
                status: false,
                message: 'Mã quận không được thiếu!'
            });
        }

        if(maxprice == 20000000) {
            maxprice = 1000000000;
        }

        if(maxarea == 200) {
            maxarea = 1000;
        }

        let bindParams = [
            minprice,
            maxprice,
            minarea,
            maxarea,
            iddistrict,
            idward
        ];

        let {result} = await exequery('SEARCH', bindParams);

        if(result == undefined) {
            return res.json({
                status: false,
                message: 'Error'
            });
        }

        return res.json({
            status: true,
            message: '',
            data: result.rows
        });
    } catch (error) {
        return res.json({
            status: false,
            message: error.message
        });
    }
});

route.post('/nearby', async(req, res) => {
    try {
        let {mlat, mlong} = req.body;

        if(mlat == '' || mlat == undefined) {
            return res.json({
                status: false,
                message: 'Vĩ độ không được thiếu!'
            });
        }

        if(mlong == '' || mlong == undefined) {
            return res.json({
                status: false,
                message: 'Kinh độ không được thiếu!'
            });
        }

        let bindParams = [];
        
        let {result} = await exequery('LIST_HOME_ACTIVE', bindParams);

        if(result == undefined) {
            return res.json({
                status: false,
                message: 'Error'
            });
        }

        var rs = [];

        for (let i = 0; i < result.rows.length; i++) {
            let {lat, long} = result.rows[i];
            if(geolib.getDistance({ latitude: mlat, longitude: mlong }, { latitude: lat, longitude: long }) <= 2000) {
                rs.push(result.rows[i]);
            }
        }

        return res.json({
            status: true,
            message: '',
            data: rs
        });

    } catch (error) {
        return res.json({
            status: false,
            message: error.message
        });
    }
});

route.post('/add-report', verifyToken, async (req, res) => {
    try {
        let {id} = req.decoded.data;
        let {idhome, reason} = req.body;

        if(idhome == '' || idhome == undefined) {
            return res.json({
                status: false,
                message: 'ID không được thiếu!'
            });
        }

        if(reason == '' || reason == undefined) {
            return res.json({
                status: false,
                message: 'Lý do không được thiếu!'
            });
        }

        let bindParams = [
            id,
            idhome,
            reason,
            0,
            'ADD'
        ];

        let {result} = await exequery('REPORT', bindParams);

        if(result == undefined) {
            return res.json({
                status: false,
                message: 'Error!'
            });
        }

        let {p_err_code, p_err_desc} = result.rows[0];

        if(p_err_code == 0) {
            return res.json({
                status: true,
                message: 'Báo cáo sai phạm thành công!'
            });
        }
        else {
            return res.json({
                status: false,
                message: p_err_desc
            });
        }

    } catch (error) {
        return res.json({
            status: false,
            message: error.message
        });
    }
});

route.post('/edit-report', verifyToken, async (req, res) => {
    try {
        let {iduser, idhome, status} = req.body;

        if(iduser == '' || iduser == undefined) {
            return res.json({
                status: false,
                message: 'ID không được thiếu!'
            });
        }

        if(idhome == '' || idhome == undefined) {
            return res.json({
                status: false,
                message: 'ID không được thiếu!'
            });
        }

        if(status == '' || status == undefined) {
            return res.json({
                status: false,
                message: 'Trạng thái không được thiếu!'
            });
        }

        let bindParams = [
            iduser,
            idhome,
            '',
            status,
            'EDIT'
        ];

        let {result} = await exequery('REPORT', bindParams);

        if(result == undefined) {
            return res.json({
                status: false,
                message: 'Error!'
            });
        }

        let {p_err_code, p_err_desc} = result.rows[0];

        if(p_err_code == 0) {
            return res.json({
                status: true,
                message: ''
            });
        }
        else {
            return res.json({
                status: false,
                message: p_err_desc
            });
        }

    } catch (error) {
        return res.json({
            status: false,
            message: error.message
        });
    }
});

route.post('/delete-report', verifyToken, async (req, res) => {
    try {
        let {role} = req.decoded.data;

        if(parseInt(role) != 1) {
            return res.json({
                status: false,
                message: 'Chỉ có Admin mới có xóa báo cáo này!'
            });
        }
        let {iduser, idhome} = req.body;

        if(iduser == '' || iduser == undefined) {
            return res.json({
                status: false,
                message: 'ID không được thiếu!'
            });
        }

        if(idhome == '' || idhome == undefined) {
            return res.json({
                status: false,
                message: 'ID không được thiếu!'
            });
        }

        let bindParams = [
            iduser,
            idhome,
            '',
            0,
            'DEL'
        ];

        let {result} = await exequery('REPORT', bindParams);

        if(result == undefined) {
            return res.json({
                status: false,
                message: 'Error!'
            });
        }

        let {p_err_code, p_err_desc} = result.rows[0];

        if(p_err_code == 0) {
            return res.json({
                status: true,
                message: 'Xóa báo cáo sai phạm thành công!'
            });
        }
        else {
            return res.json({
                status: false,
                message: p_err_desc
            });
        }

    } catch (error) {
        return res.json({
            status: false,
            message: error.message
        });
    }
});
 

exports.HOME_ROUTER = route