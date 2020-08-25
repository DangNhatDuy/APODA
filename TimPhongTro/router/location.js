const express = require('express');
const route = express.Router();
const {exequery} = require('./../menu');

route.get('/city', async (req, res) => {
    try {
        let bindParams = [];
         
        let {result} = await exequery('CITY', bindParams);

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

route.get('/district', async (req, res) => {
    try {
        let bindParams = [];
         
        let {result} = await exequery('DISTRICT', bindParams);

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

route.get('/ward', async (req, res) => {
    try {
        let bindParams = [];
         
        let {result} = await exequery('WARD', bindParams);

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

exports.LOCATION_ROUTER = route;