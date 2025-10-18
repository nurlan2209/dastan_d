const mongoose = require("mongoose");

const orderSchema = new mongoose.Schema({
  clientId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
    required: true,
  },
  photographerId: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
  service: { type: String, required: true },
  date: { type: Date, required: true },
  location: { type: String, required: true },
  status: {
    type: String,
    enum: ["new", "assigned", "in_progress", "completed", "archived"],
    default: "new",
  },
  price: { type: Number, required: true },
  result: { type: String },
  comment: { type: String },
  createdAt: { type: Date, default: Date.now },
});

module.exports = mongoose.model("Order", orderSchema);
