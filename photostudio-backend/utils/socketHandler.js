const Notification = require("../models/Notification");

let io;

exports.initSocket = (socketIO) => {
  io = socketIO;
  io.on("connection", (socket) => {
    socket.on("join", (userId) => {
      socket.join(userId);
    });
  });
};

exports.sendNotification = async (userId, message, type) => {
  await Notification.create({ userId, message, type });
  if (io) {
    io.to(userId.toString()).emit("notification", { message, type });
  }
};
