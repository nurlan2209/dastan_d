const mongoose = require("mongoose");

const VerificationCodeSchema = new mongoose.Schema(
  {
    email: {
      type: String,
      required: true,
      index: true
    },
    code: {
      type: String,
      required: true
    },
    type: {
      type: String,
      enum: ["email_verification", "password_reset"],
      required: true
    },
    expiresAt: {
      type: Date,
      required: true,
      index: true
    },
    isUsed: {
      type: Boolean,
      default: false
    }
  },
  { timestamps: true }
);

// Автоматическое удаление просроченных кодов
VerificationCodeSchema.index({ expiresAt: 1 }, { expireAfterSeconds: 0 });

module.exports = mongoose.model("VerificationCode", VerificationCodeSchema);
