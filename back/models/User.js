const mongoose = require("mongoose");

const UserSchema = new mongoose.Schema(
  {
    name: { type: String, required: true },
    email: { type: String, required: true, unique: true },
    password: { type: String, required: true },
    role: {
      type: String,
      enum: ["client", "photographer", "admin"],
      default: "client",
    },
    phone: { type: String, default: "" },
    rating: { type: Number, default: 0 },
    reviewsCount: { type: Number, default: 0 },
    isActive: { type: Boolean, default: true },
    emailVerified: { type: Boolean, default: false },
  },
  { timestamps: true }
);

// --- ИСПРАВЛЕНИЕ ЗДЕСЬ ---
// Было: module.exports = mongoose.model("User", userSchema);
// Стало:
module.exports = mongoose.model("User", UserSchema);
