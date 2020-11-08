const express = require('express');
const route = express.Router();
const {exequery} = require('./../menu');
const upload = require('./../utils/multer.config');
const {verifyToken} = require('./../middleware/checkToken')

route.post('/upload', verifyToken, upload.array('image', 1), async (req, res) => {
    try {
        let imageName = req.files[0].filename;
        let {id} = req.decoded.data;
        let {title, description, address, idward} = req.body;

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
        let {id, title, description, address, idward} = req.body;

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

route.post('/verify', verifyToken, async (req, res) => {
    try {
        let {id} = req.body;

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
 

exports.HOME_ROUTER = route