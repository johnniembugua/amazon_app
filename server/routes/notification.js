const express = require("express");
const fetch = require("node-fetch");
// const auth = require("../middlewares/auth");

const notificationRouter = express.Router();

notificationRouter.post("/api/notification/send", (req, res) => {
  const { title, body, tokens } = req.body;
  //   console.log(tokens[0]);
  var notification = {
    title: title,
    body: body,
    image:
      "https://images.unsplash.com/photo-1548248823-ce16a73b6d49?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=776&q=80",
  };

  let fcm_tokens = [];

  for (let i = 0; i < tokens.length; i++) {
    fcm_tokens.push(tokens[i].toString());
  }

  console.log(fcm_tokens);

  var notification_body = {
    notification: {
      title: title,
      body: body,
      image:
        "https://images.unsplash.com/photo-1548248823-ce16a73b6d49?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=776&q=80",
    },
    registration_ids: fcm_tokens,
    data: {
      route: "/notification",
    },
  };

  fetch("https://fcm.googleapis.com/fcm/send", {
    method: "POST",
    headers: {
      Authorization:
        "key=" +
        "AAAAJSDKLkM:APA91bFhMOnRyl9tj3FoE2evCjIWXSQleoMvmtu7jKbMfuoFDtzpKSZjwJQ_zdpZMClk2JrmogLMay1faQHriPQ_rNJ4uNbqhrFyQMF95bXHgFeB0xu42bYkEJBcYXxnryVHSfKYFOwT",
      "Content-Type": "application/json",
    },
    body: JSON.stringify(notification_body),
  })
    .then(() => {
      res.status(200).json({ message: "Notification sent successfully" });
    })
    .catch((err) => {
      console.log(err);
      res.status(400).json({ error: "Something went wrong" });
    });
});

module.exports = notificationRouter;
