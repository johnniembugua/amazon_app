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

// Get all products
adminRouter.get('/admin/get-products',admin,async(req,res)=>{
    try {
        const products=await Product.find({});
        res.json(products);
    } catch (e) {
        res.status(500).json({error:e.message});
    }
});

//update product
adminRouter.put('/admin/update-product',admin,async(req,res)=>{
    try {
        const { id, name, description,images,price,quantity,category}=req.body;

        let product= await Product.findByIdAndUpdate(id);
        product=  Product({
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
//delete product
adminRouter.post('/admin/delete-product',admin,async(req,res)=>{
    try {
        const {id}=req.body;
        let product=await Product.findByIdAndDelete(id);
        
        res.json(product);
    } catch (e) {
        res.status(500).json({error:e.message});
    }
});

module.exports=adminRouter;