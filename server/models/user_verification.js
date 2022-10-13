const mongoose=require("mongoose");
const { productSchema } = require("./product");

const userVerificationSchema=mongoose.Schema({
    userId:{
        required:true,
        type:String,
        trim:true,

    },
    uniqueString:{
        required:true,
        type:String,
        trim:true,
        

    },
    createdAt:{
        required:true,
        type:Date,
    },
    expiresAt:{
        type:Date,
        required:false,
    },
});

const UserVerification=mongoose.model("UserVerification",userVerificationSchema);

module.exports=UserVerification