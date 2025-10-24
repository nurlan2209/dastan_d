const mongoose = require("mongoose");

const scheduleSchema = new mongoose.Schema({
  photographerId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
    required: true,
  },
  date: { type: Date, required: true },
  startTime: { type: String, required: true },
  endTime: { type: String, required: true },
  available: { type: Boolean, default: true },
});

module.exports = mongoose.model("Schedule", scheduleSchema);
