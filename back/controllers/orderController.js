const Order = require("../models/Order");

exports.createOrder = async (req, res) => {
  try {
    const order = await Order.create({ ...req.body, clientId: req.user.id });
    res.status(201).json(order);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getOrders = async (req, res) => {
  try {
    const filter = {};
    if (req.user.role === "photographer") filter.photographerId = req.user.id;
    if (req.user.role === "client") filter.clientId = req.user.id;
    if (req.query.status) filter.status = req.query.status;
    const orders = await Order.find(filter)
      .populate("clientId", "name email phone")
      .populate("photographerId", "name email rating")
      .populate("serviceId", "name price duration description");

    res.json(orders);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getOrderById = async (req, res) => {
  try {
    const order = await Order.findById(req.params.id)
      .populate("clientId photographerId")
      .populate("serviceId", "name price duration description");
    if (!order) return res.status(404).json({ message: "Order not found" });
    res.json(order);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.updateOrder = async (req, res) => {
  try {
    const order = await Order.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
    })
      .populate("clientId", "name email phone")
      .populate("photographerId", "name email rating")
      .populate("serviceId", "name price duration description");

    if (!order) {
      return res.status(404).json({ message: "Order not found" });
    }

    res.json(order);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.deleteOrder = async (req, res) => {
  try {
    await Order.findByIdAndDelete(req.params.id);
    res.json({ message: "Order deleted" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
