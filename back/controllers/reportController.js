const Order = require("../models/Order");
const Review = require("../models/Review");
const { generatePDF } = require("../utils/pdfGenerator");
const { generateCSV } = require("../utils/csvExporter");

exports.getStatistics = async (req, res) => {
  try {
    const { startDate, endDate } = req.query;
    const filter = {
      createdAt: { $gte: new Date(startDate), $lte: new Date(endDate) },
    };

    const orders = await Order.find(filter);
    const totalRevenue = orders.reduce((sum, o) => sum + o.price, 0);
    const totalOrders = orders.length;

    res.json({ totalRevenue, totalOrders, orders });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.exportPDF = async (req, res) => {
  try {
    const orders = await Order.find().populate(
      "clientId photographerId",
      "name"
    );
    const pdfBuffer = await generatePDF(orders);
    res.setHeader("Content-Type", "application/pdf");
    res.send(pdfBuffer);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.exportCSV = async (req, res) => {
  try {
    const orders = await Order.find().populate(
      "clientId photographerId",
      "name"
    );
    const csv = await generateCSV(orders);
    res.setHeader("Content-Type", "text/csv");
    res.send(csv);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
