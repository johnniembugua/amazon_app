//IMPORT FROM PACKAGES
const express = require("express");
const mongoose = require("mongoose");
require("dotenv").config();
const cors = require("cors");

//IMPORT FROM OTHER FILES
const authRouter = require("./routes/auth");
const adminRouter = require("./routes/admin");
const productRouter = require("./routes/product");
const userRouter = require("./routes/user");
const notificationRouter = require("./routes/notification");
const { db } = require("./models/user");

//INIT
const PORT = process.env.PORT || 3000;
const DB = "mongodb://localhost:27017/amazon?retryWrites=true&w=majority";

const app = express();

//middllewares
app.use(express.json());
app.use(cors());
app.use(authRouter);
app.use(adminRouter);
app.use(productRouter);
app.use(userRouter);
app.use(notificationRouter);
app.use("/uploads", express.static("uploads"));

//Connections
mongoose
  .connect(DB)
  .then((client) => {
    console.log("Connection to database successful");
  })
  .catch((e) => {
    console.log(e);
  });

app.listen(PORT, "0.0.0.0", () => {
  console.log(`Connected at port ${PORT}`);
});
