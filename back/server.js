// photostudio-backend/server.js
const express = require("express");
const cors = require("cors");
const helmet = require("helmet");
const connectDB = require("./config/db");
const {
  errorHandler,
  notFoundHandler,
} = require("./middleware/errorHandler");

require("dotenv").config();

const app = express();

connectDB();

app.use(helmet());
app.use(cors());
app.use(express.json());

// Health check endpoint
app.get("/health", (req, res) => {
  res.json({ status: "OK", message: "Server is running" });
});

// API routes
app.use("/api/auth", require("./routes/authRoutes"));
app.use("/api/users", require("./routes/userRoutes"));
app.use("/api/orders", require("./routes/orderRoutes"));
app.use("/api/reviews", require("./routes/reviewRoutes"));
app.use("/api/schedule", require("./routes/scheduleRoutes"));
app.use("/api/reports", require("./routes/reportRoutes"));
app.use("/api/services", require("./routes/serviceRoutes"));

// 404 handler
app.use(notFoundHandler);

// Error handler (должен быть последним)
app.use(errorHandler);

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`🚀 Server running on port ${PORT}`));
