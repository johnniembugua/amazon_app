const express=require('express');
const admin=require('../middlewares/admin');
const Product=require('../models/product');

const adminRouter=express.Router();


//Add product

adminRouter.post('/admin/add-product',admin,async(req,res)=>{
    try {
        const {name, description,images,price,quantity,category}=req.body;
        let product=new Product({
            name,
            description,
            images,
            price,
            quantity,
            category
        });
        product=await product.save();
        res.json(product);
    } catch (e) {
        res.status(500).json({error:e.message});
    }
});

module.exports=adminRouter;