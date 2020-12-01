const express = require('express');
const route = express.Router();
const {exequery} = require('./../menu');
const upload = require('./../utils/multer.config');
const { verifyToken } = require('./../middleware/checkToken');

route.post('/', async (req, res) => {
    try {
        let {idhome} = req.body;

        if(idhome == '' || idhome == undefined) {
            return res.json({
                status: false,
                message: 'ID bài đăng không được thiếu!'
            });
        }

        let bindParams = [idhome];

        let {result} = await exequery('LIST_ROOM', bindParams);

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
})

route.post('/upload', verifyToken, upload.array('image', 1), async (req, res) => {
    try {
        let imageName = req.files[0].filename;
        let {price, area, description, maximum, idhome} = req.body;

        if(price == '' || price == undefined) {
            return res.json({
                status: false,
                message: 'Giá phòng không được thiếu!'
            });
        }

        if(area == '' || area == undefined) {
            return res.json({
                status: false,
                message: 'Diện tích phòng không được thiếu!'
            });
        }

        if(description == '' || description == undefined) {
            return res.json({
                status: false,
                message: 'Miêu tả phòng không được thiếu!'
            });
        }

        if(maximum == '' || maximum == undefined) {
            return res.json({
                status: false,
                message: 'Số người ở tối đa không được thiếu!'
            });
        }

        if(idhome == '' || idhome == undefined) {
            return res.json({
                status: false,
                message: 'ID bài đăng không được thiếu!'
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
            price,
            area,
            description,
            maximum,
            imageName,
            -1,
            idhome,
            'ADD'
        ];

        let {result} = await exequery('ROOM', bindParams);

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
                message: 'Thêm phòng thành công!'
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

route.post('/update', verifyToken, upload.array('image', 1), async (req, res) =>{
    try {
        let imageName = req.files[0].filename;
        let {id, price, area, description, maximum} = req.body;

        if(id == '' || id == undefined) {
            return res.json({
                status: false,
                message: 'ID phòng không được thiếu!'
            });
        }

        if(price == '' || price == undefined) {
            return res.json({
                status: false,
                message: 'Giá phòng không được thiếu!'
            });
        }

        if(area == '' || area == undefined) {
            return res.json({
                status: false,
                message: 'Diện tích phòng không được thiếu!'
            });
        }

        if(description == '' || description == undefined) {
            return res.json({
                status: false,
                message: 'Miêu tả phòng không được thiếu!'
            });
        }

        if(maximum == '' || maximum == undefined) {
            return res.json({
                status: false,
                message: 'Số người ở tối đa không được thiếu!'
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
            price,
            area,
            description,
            maximum,
            imageName,
            -1,
            -1,
            'EDIT'
        ];

        let {result} = await exequery('ROOM', bindParams);

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

route.post('/delete', verifyToken, async (req, res) => {
    try {
        let {id} = req.body;

        if(id == '' || id == undefined) {
            return res.json({
                status: false,
                message: 'ID phòng không được thiếu!'
            });
        }

        let bindParams = [
            id,
            -1,
            -1,
            '',
            -1,
            '',
            -1,
            -1,
            'DEL'
        ];

        let {result} = await exequery('ROOM', bindParams);

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

route.post('/detail', async (req, res) => {
    try {
        let {id} = req.body;

        if(id == '' || id == undefined) {
            return res.json({
                status: false,
                message: 'ID phòng không được thiếu!'
            });
        }

        let bindParams = [id];

        let {result} = await exequery('ROOM_DETAIL', bindParams);

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

route.post('/change-status', verifyToken, async (req, res) => {
    try {
        let {idroom, status} = req.body;

        if(idroom == '' || idroom == undefined) {
            return res.json({
                status: false,
                message: 'ID phòng không được thiếu!'
            });
        }

        if(status == '' || status == undefined) {
            return res.json({
                status: false,
                message: 'Trạng thái phòng không được thiếu!'
            });
        }

        let bindParams = [
            idroom,
            status
        ];

        let {result} = await exequery('ROOM_STATUS', bindParams);

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
                message: 'Thay đổi trạng thái phòng thành công!'
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

route.post('/appointment-info', verifyToken, async (req, res) => {
    try {
        let {id} = req.body;

        if(id == '' || id == undefined) {
            return res.json({
                status: false,
                message: 'ID phòng không được thiếu!'
            });
        }

        let bindParams = [id];

        let {result} = await exequery('APPOINTMENT_INFO', bindParams);

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

route.post('/appointment', verifyToken, async (req, res) => {
    try {
        let {id} = req.decoded.data;
        let {idroom, date} = req.body;

        if(idroom == '' || idroom == undefined) {
            return res.json({
                status: false,
                message: 'ID phòng không được thiếu!'
            });
        }

        if(date == '' || date == undefined) {
            return res.json({
                status: false,
                message: 'Ngày không được thiếu!'
            });
        }

        let bindParams = [
            id,
            idroom,
            date,
            'ADD'
        ];

        let {result} = await exequery('APPOINTMENT', bindParams);

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
                message: 'Đặt lịch hẹn xem phòng thành công!'
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

route.post('/appointment/edit', verifyToken, async (req, res) => {
    try {
        let {id} = req.decoded.data;
        let {idroom, date} = req.body;

        if(idroom == '' || idroom == undefined) {
            return res.json({
                status: false,
                message: 'ID phòng không được thiếu!'
            });
        }

        if(date == '' || date == undefined) {
            return res.json({
                status: false,
                message: 'Ngày không được thiếu!'
            });
        }

        let bindParams = [
            id,
            idroom,
            date,
            'EDIT'
        ];

        let {result} = await exequery('APPOINTMENT', bindParams);

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
                message: 'Thay đổi lịch hẹn xem phòng thành công!'
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

route.post('/appointment/delete', verifyToken, async (req, res) => {
    try {
        let {iduser, idroom} = req.body;

        if(iduser == '' || iduser == undefined) {
            return res.json({
                status: false,
                message: 'ID user không được thiếu!'
            });
        }

        if(idroom == '' || idroom == undefined) {
            return res.json({
                status: false,
                message: 'ID phòng không được thiếu!'
            });
        }

        let bindParams = [
            iduser,
            idroom,
            '2021-01-01 00:00:00',
            'DEL'
        ];

        let {result} = await exequery('APPOINTMENT', bindParams);

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
                message: 'Xóa lịch hẹn xem phòng thành công!'
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

exports.ROOM_ROUTER = route