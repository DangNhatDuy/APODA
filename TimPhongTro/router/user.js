const express = require('express');
const route = express.Router(); //dieu huong
const {hashPwd, comparePwd} = require('./../utils/bcrypt.promise');
const {exequery} = require('./../menu');
const {signPromise, verifyPromise} = require('./../utils/jwt');
const { verifyToken } = require('../middleware/checkToken');
const upload = require('./../utils/multer.config');

route.post('/login', async (req, res) => {
    try {
        let {email, password} = req.body;

        if(email == '' || email == undefined) {
            return res.json({
                status: false,
                message: 'Email không được thiếu!'
            });
        }

        if(password == '' || password == undefined) {
            return res.json({
                status: false,
                message: 'Mật khẩu không được thiếu!'
            });
        }

        let bindParams = [
            email
        ]

        let {result} = await exequery('LOGIN', bindParams);

        if(result == undefined) {
            return res.json({
                status: false,
                message: 'Error'
            });
        }

        let {p_err_code, p_err_desc} = result.rows[0];

        if(p_err_code == 0) {
            let {p_id, p_email, p_password, p_name, p_phone, p_avatar, p_active, p_idrole} = result.rows[0];

            let signalPWD = await comparePwd(password, p_password.trim());
            if(signalPWD.err) {
                return res.json({
                    status: false,
                    message: 'Mật khẩu không đúng!'
                });
            }

            let signToken = await signPromise({
                id: p_id,
                email: p_email,
                name: p_name,
                phone: p_phone,
                active: p_active,
                role: p_idrole
            });
            
            if(signToken.error) {
                return res.json({
                    status: false,
                    message: signToken.message
                });
            }

            return res.json({
                status: true,
                message: '',
                data: {
                    id: parseInt(p_id),
                    email: p_email,
                    u_name: p_name,
                    phone: p_phone,
                    avatar: p_avatar,
                    active: parseInt(p_active),
                    u_role: parseInt(p_idrole),
                    access_token: signToken.token
                }
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

route.post('/register', async (req, res) => {
    try {
        let {email, password, name, phone, idrole} = req.body;

        if(email == '' || email == undefined) {
            return res.json({
                status: false,
                message: 'Email không được thiếu!'
            });
        }

        if(password == '' || password == undefined) {
            return res.json({
                status: false,
                message: 'Mật khẩu không được thiếu!'
            });
        }

        if(name == '' || name == undefined) {
            return res.json({
                status: false,
                message: 'Tên không được thiếu!'
            });
        }

        if(phone == '' || phone == undefined) {
            return res.json({
                status: false,
                message: 'Số điện thoại không được thiếu!'
            });
        }

        if(idrole == '' || idrole == undefined) {
            return res.json({
                status: false,
                message: 'Role không được thiếu!'
            });
        }

        let pwd = await hashPwd(password);

        let bindParams = [
            -1,
            email,
            pwd,
            name,
            phone,
            '',
            -1,
            idrole,
            'ADD'
        ]

        let {result} = await exequery('USER', bindParams);

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
                message: 'Đăng ký tài khoản thành công!'
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
});

route.post('/info', verifyToken, async (req, res) => {
    try {
        let {id} = req.decoded.data;

        let bindParams = [
            id
        ];

        let {result} = await exequery('USER_INFO', bindParams);

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

route.post('/update', verifyToken, async (req, res) => {
    try {
        let {id} = req.decoded.data;
        let {name, phone} = req.body;

        if(name == '' || name == undefined) {
            return res.json({
                status: false,
                message: 'Tên không được thiếu!'
            });
        }

        if(phone == '' || phone == undefined) {
            return res.json({
                status: false,
                message: 'Số điện thoại không được thiếu!'
            });
        }

        let bindParams = [
            id,
            '',
            '',
            name,
            phone,
            '',
            -1,
            -1,
            'EDIT'
        ];

        let {result} = await exequery('USER', bindParams);

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
                message: 'Thay đổi thông tin thành công!'
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
});

route.post('/upload', verifyToken, upload.array('image', 1), async (req, res) => {
    try {
        let imageName = req.files[0].filename;
        let {id} = req.decoded.data;
        let {name, phone} = req.body;

        if(name == '' || name == undefined) {
            return res.json({
                status: false,
                message: 'Tên không được thiếu!'
            });
        }

        if(phone == '' || phone == undefined) {
            return res.json({
                status: false,
                message: 'Số điện thoại không được thiếu!'
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
            '',
            '',
            name,
            phone,
            imageName,
            -1,
            -1,
            'EDIT'
        ];

        let {result} = await exequery('USER', bindParams);

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
                message: 'Thay đổi thông tin thành công!'
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
});

route.post('/home-reservation', verifyToken, async (req, res) => {
    try {
        let {id} = req.decoded.data;

        let bindParams = [
            id
        ];

        let {result} = await exequery('HOME_RESERVATION', bindParams);

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

route.post('/room-reservation', verifyToken, async (req, res) => {
    try {
        let {id} = req.decoded.data;
        let {idhome} = req.body;

        let bindParams = [
            id,
            idhome
        ];

        let {result} = await exequery('ROOM_RESERVATION', bindParams);

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

route.post('/change-password', verifyToken, async (req, res) => {
    try {
        let {id} = req.decoded.data;
        let {oldpwd, newpwd} = req.body;

        if(oldpwd == '' || oldpwd == undefined) {
            return res.json({
                status: false,
                message: 'Mật khẩu cũ không được thiếu!'
            });
        }

        if(newpwd == '' || newpwd == undefined) {
            return res.json({
                status: false,
                message: 'Mật khẩu mới không được thiếu!'
            });
        }

        let param = [
            id
        ];

        var {result} = await exequery('GET_PASSWORD', param);

        if(result == undefined) {
            return res.json({
                status: false,
                message: 'Error'
            });
        }

        var {p_err_code, p_err_desc} = result.rows[0];

        if(p_err_code == 0) {
            let {p_password} = result.rows[0];

            let signalPWD = await comparePwd(oldpwd, p_password.trim());
            if(signalPWD.err) {
                return res.json({
                    status: false,
                    message: 'Mật khẩu cũ không đúng!'
                });
            }
            let pwd = await hashPwd(newpwd);
            let bindParams = [
                id,
                pwd
            ];

            var {result} = await exequery('CHANGE_PASSWORD', bindParams);

            if(result == undefined) {
                return res.json({
                    status: false,
                    message: 'Error'
                });
            }

            var {p_err_code, p_err_desc} = result.rows[0];

            if(p_err_code == 0) {
                return res.json({
                    status: true,
                    message: 'Thay đổi mật khẩu thành công!'
                });
            }

            else {
                return res.json({
                    status: false,
                    message: p_err_desc
                });
            }
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

route.post('/my-home', verifyToken, async (req, res) => {
    try {
        let {id} = req.decoded.data;

        let bindParams = [
            id
        ];

        let {result} = await exequery('MY_HOME', bindParams);

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

route.get('/list', verifyToken, async (req, res) => {
    try {
        let {role} = req.decoded.data;

        if(parseInt(role) != 1) {
            return res.json({
                status: false,
                message: 'Chỉ có Admin mới có quyền xem danh sách này!'
            });
        }

        let bindParams = [];

        let {result} = await exequery('LIST_USER', bindParams);

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


exports.USER_ROUTER = route;