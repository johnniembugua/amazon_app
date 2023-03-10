const express = require("express");
const axios = require("axios");
const auth = require("../middlewares/auth");
const { Product } = require("../models/product");
const productRouter = express.Router();

// api/product?category=Essentials
productRouter.get("/api/products", auth, async (req, res) => {
  try {
    var model = {
      pageSize: req.query.pageSize,
      page: req.query.page,
      sort: req.query.sort,
      category: req.query.category,
    };
    let perPage = Math.abs(model.pageSize) || 10;
    let page = (Math.abs(model.page) || 1) - 1;

    const products = await Product.find({ category: model.category })
      .sort(model.sort)
      .limit(perPage)
      .skip(perPage * page);
    res.json(products);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});
// api to search products and get them
productRouter.get("/api/products/search/:name", auth, async (req, res) => {
  try {
    const products = await Product.find({
      name: { $regex: req.params.name, $options: "i" },
    });
    res.json(products);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});
//create a post request to rate product.
productRouter.post("/api/rate-product", auth, async (req, res) => {
  try {
    const { id, rating } = req.body;
    let product = await Product.findById(id);

    for (let i = 0; i < product.ratings.length; i++) {
      if (product.ratings[i].userId == req.user) {
        product.ratings.splice(i, 1);
        break;
      }
    }

    const ratingSchema = {
      userId: req.user,
      rating,
    };

    product.ratings.push(ratingSchema);
    product = await product.save();
    res.json(product);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

productRouter.get("/api/deal-of-day", auth, async (req, res) => {
  try {
    let products = await Product.find({});

    products = products.sort((a, b) => {
      let aSum = 0;
      let bSum = 0;

      for (let i = 0; i < a.ratings.length; i++) {
        aSum += a.ratings[i].rating;
      }

      for (let i = 0; i < b.ratings.length; i++) {
        bSum += b.ratings[i].rating;
      }
      return aSum < bSum ? 1 : -1;
    });

    res.json(products[0]);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});
// productRouter.get("/api/token", async (req, res) => {
//   generateToken();
// });
let token = "";
const generateToken = async (req, res, next) => {
  const secret = process.env.MPESA_SECRETKEY;
  const consumer = process.env.MPESA_CONSUMERKEY;
  const auth = new Buffer.from(`${consumer}:${secret}`).toString("base64");
  await axios
    .get(
      "https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials",
      {
        headers: {
          authorization: `Basic ${auth}`,
        },
      }
    )
    .then((res) => {
      token = res.data.access_token;
      next();
    })
    .catch((error) => {
      console.log(error);
      res.status(400).json(error.message);
    });
};
productRouter.post("/api/stk", generateToken, async (req, res) => {
  const { phone, amount } = req.body;

  const date = new Date();
  const timestamp =
    date.getFullYear() +
    ("0" + (date.getMonth() + 1)).slice(-2) +
    ("0" + (date.getDate() + 1)).slice(-2) +
    ("0" + (date.getHours() + 1)).slice(-2) +
    ("0" + (date.getMinutes() + 1)).slice(-2) +
    ("0" + (date.getSeconds() + 1)).slice(-2);

  const shortcode = process.env.MPESA_PAYBILL;
  const passkey = process.env.MPESA_PASSKEY;
  const password = new Buffer.from(shortcode + passkey + timestamp).toString(
    "base64"
  );

  await axios
    .post(
      "https://sandbox.safaricom.co.ke/mpesa/stkpush/v1/processrequest",
      {
        BusinessShortCode: shortcode,
        Password: password,
        Timestamp: timestamp,
        TransactionType: "CustomerPayBillOnline",
        Amount: amount,
        PartyA: `254${phone.substring(1)}`,
        PartyB: shortcode,
        PhoneNumber: `2547${phone.substring(1)}`,
        CallBackURL: "https://mydomain.com/pat",
        AccountReference: `2547${phone.substring(1)}`,
        TransactionDesc: "Test",
      },
      {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      }
    )
    .then((res) => {
      console.log(res.data);
      res.status(200).json(res.data);
    })
    .catch((error) => {
      console.log(error.message);
      res.status(400).json(error.message);
    });
});

module.exports = productRouter;
