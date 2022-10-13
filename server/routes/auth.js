const express = require("express");
const bcryptjs = require("bcryptjs");
const jwt = require("jsonwebtoken");

const User = require("../models/user");

const UserVerification = require("../models/user_verification");

const auth = require("../middlewares/auth");

const authRouter = express.Router();

//email handler
const nodemailer = require("nodemailer");

//unique string
const { v4: uuidv4 } = require("uuid");

// env variables
require("dotenv").config();

//path for static verified page
const path = require("path");

// nodemailer staff
let transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: process.env.AUTH_EMAIL,
    pass: process.env.AUTH_PASS,
  },
});

// testing success
transporter.verify((error, success) => {
  if (error) {
    console.log(error);
  } else {
    console.log("Ready for messages");
    console.log(success);
  }
});

authRouter.post("/api/signup", async (req, res) => {
  try {
    const { name, email, password } = req.body;

    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res
        .status(400)
        .json({ msg: "User with same email already exists!" });
    }
    const hashedPassword = await bcryptjs.hash(password, 8);

    let user = new User({
      email,
      password: hashedPassword,
      name,
      verified: false,
    });
    user = await user.save();
    //sendVerificationEmail(user, res);
    res.json({ user });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

//send verification email
const sendVerificationEmail =  ({ _id, email }, res) => {
  //url to be used in the email
  const currentUrl = "http:/localhost:3000/";

  const uniqueString = uuidv4() + _id;

  const mailOptions = {
    from: process.env.AUTH_EMAIL,
    to: email,
    subject: "Verify Your Email",
    html: `<p>Verify your email address to complete the signup process and login into your account.</p><p>This link <b>expires in 6 hours</b>.</p><p>Press <a href=${
      currentUrl + "api/verify/" + _id + "/" + uniqueString
    }>here</a> to proceed.</p> `,
  };
  // hash the uniqueString
  const saltRounds = 10;
  bcryptjs
    .hash(uniqueString, saltRounds)
    .then((hashedUniqueString) => {
      // set values in userVerification collection
      const newVerification = new UserVerification({
        userId: _id,
        uniqueString: hashedUniqueString,
        createdAt: Date.now(),
        expiresAt: Date.now() + 21600000,
      });
      newVerification
        .save()
        .then(() => {
          transporter
            .sendMail(mailOptions)
            .then(() => {
              //email sent and verification record saved
              res.json({
                status: "Pending",
                message: "Verification email sent",
              });
            })
            .catch((error) => {
              console.log(error);
              res.status(500).json({ error: error.message });
            });
        })
        .catch((e) => {
          res.status(500).json({ error: e.message });
        });
    })
    .catch((e) => {
      res.status(500).json({ error: e.message });
    });
};

// verify email
authRouter.get("/api/verify/:userId/:uniqueString",  (req, res) => {
  
    let { userId, uniqueString } = req.params;

    UserVerification.find({ userId })
      .then((result) => {
        if (result.length > 0) {
          //user verification record exist
          const { expiresAt } = result[0];
          const hashedUniqueString = result[0].uniqueString;

          // checking for expired unique String
          if (expiresAt < Date.now()) {
            //record has expired so we delete it
            UserVerification.deleteOne({ userId })
              .then((result) => {
                UserVerification.deleteOne({ _id: userId })
                  .then(() => {
                    let message = "Link has expired. Please signup again";
                    res.redirect(`/api/verified/?error=true&message=${message}`);
                  })
                  .catch((e) => {
                    console.log(e);
                    let message =
                      "Clearing user with expired unique  user string failed";
                    res.redirect(`/api/verified/?error=true&message=${message}`);
                  });
              })
              .catch((e) => {
                console.log(e);
                let message =
                  "An error occurred while clearing expired user verification record";
                res.redirect(`/api/verified/?error=true&message=${message}`);
              });
          } else {
            // valid record exists so we validate the user string
            //first compare the hashed unque string

            bcryptjs
              .compare(uniqueString, hashedUniqueString)
              .then((result) => {
                if (result) {
                  //string match
                  User.updateOne({ _id: userId }, { verified: true })
                    .then(() => {
                      UserVerification.deleteOne({ userId })
                        .then(() => {
                          res.sendFile(
                            path.join(__dirname, "./../views/verified.html")
                          );
                        })
                        .catch((e) => {
                          console.log(e);
                          let message =
                            "An error occured while finalizing successful verification";
                          res.redirect(
                            `/api/verified/?error=true&message=${message}`
                          );
                        });
                    })
                    .catch((error) => {
                      let message =
                        "An error occured while updating user record";
                      res.redirect(
                        `/api/verified/?error=true&message=${message}`
                      );
                    });
                } else {
                  //existing record but incorrect verification details passed
                  let message =
                    "Invalid verification details passed. Check your inbox";
                  res.redirect(`/api/verified/?error=true&message=${message}`);
                }
              })
              .catch((e) => {
                console.log(e);
                let message =
                  "An error occurred while comparing unique strings";
                res.redirect(`/api/verified/?error=true&message=${message}`);
              });
          }
        } else {
          //user verification record doesnt exist

          let message =
            "Account record doesnt exist or has been verified already. Please sign up or login";
          res.redirect(`/api/verified/?error=true&message=${message}`);
        }
      })
      .catch((e) => {
        console.log(error);
        let message =
          "An error occured while checking for existing user verification record";
        res.redirect(`/api/verified/?error=true&message=${message}`);
      });
  } 
);

//verify page route
authRouter.get("/api/verified", async (req, res) => {
  res.sendFile(path.join(__dirname, "./../views/verified.html"));
});

//Signin route
authRouter.post("/api/signin", async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await User.findOne({ email });
    if (!user) {
      return res
        .status(400)
        .json({ msg: "User with this email address does not exist" });
    }
    //check if user is verified
    // if (!user.verified) {
    //   res
    //     .status(500)
    //     .json({ error: "User has not been verified. Check your inbox" });
    // }
    const isMatch = await bcryptjs.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ msg: "Incorrect email/password" });
    }
    const token = jwt.sign({ id: user._id }, "passwordKey");
    res.json({ token, ...user._doc });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

//isTokenValid route
authRouter.post("/tokenIsValid", async (req, res) => {
  try {
    const token = req.header("x-auth-token");
    if (!token) return res.json(false);
    const verified = jwt.verify(token, "passwordKey");
    if (!verified) return res.json(false);

    const user = await User.findById(verified.id);
    if (!user) return res.json(false);
    res.json(true);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

//get user data
authRouter.get("/", auth, async (req, res) => {
  const user = await User.findById(req.user);
  res.json({ ...user._doc, token: req.token });
});

module.exports = authRouter;
