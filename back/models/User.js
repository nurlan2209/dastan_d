const mongoose = require("mongoose");

const UserSchema = new mongoose.Schema(
  {
    fullName: { type: String, required: true },
    email: { type: String, required: true, unique: true },
    password: { type: String, required: true },
    role: {
      type: String,
      enum: ["client", "photographer", "admin"],
      default: "client",
    },
    phoneNumber: { type: String, default: "" },
    rating: { type: Number, default: 0 },
    reviewsCount: { type: Number, default: 0 },
    isActive: { type: Boolean, default: true },
    emailVerified: { type: Boolean, default: true },
  },
  { timestamps: true }
);

// --- ИСПРАВЛЕНИЕ ЗДЕСЬ ---
// Было: module.exports = mongoose.model("User", userSchema);
// Стало:
module.exports = mongoose.model("User", UserSchema);
