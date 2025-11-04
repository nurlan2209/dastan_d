const Order = require("../models/Order");
const Review = require("../models/Review");
const User = require("../models/User");
const { generatePDF } = require("../utils/pdfGenerator");
const { generateCSV } = require("../utils/csvExporter");

// Получить полную статистику для админ-панели
exports.getSummary = async (req, res) => {
  try {
    // Общая статистика по заказам (исключая отмененные)
    const totalOrders = await Order.countDocuments({ status: { $ne: "cancelled" } });
    const totalRevenue = await Order.aggregate([
      { $match: { status: { $ne: "cancelled" } } },
      { $group: { _id: null, total: { $sum: "$price" } } },
    ]);

    // Статистика по статусам заказов
    const ordersByStatus = await Order.aggregate([
      { $group: { _id: "$status", count: { $sum: 1 } } },
    ]);

    // Статистика по пользователям
    const userStats = await User.aggregate([
      { $group: { _id: "$role", count: { $sum: 1 } } },
    ]);

    // Топ-5 фотографов по количеству заказов (исключая отмененные)
    const topPhotographersByOrders = await Order.aggregate([
      { $match: { photographerId: { $ne: null }, status: { $ne: "cancelled" } } },
      { $group: { _id: "$photographerId", orderCount: { $sum: 1 } } },
      { $sort: { orderCount: -1 } },
      { $limit: 5 },
      {
        $lookup: {
          from: "users",
          localField: "_id",
          foreignField: "_id",
          as: "photographer",
        },
      },
      { $unwind: "$photographer" },
      {
        $project: {
          _id: 1,
          name: "$photographer.fullName",
          email: "$photographer.email",
          rating: "$photographer.rating",
          orderCount: 1,
        },
      },
    ]);

    // Топ-5 фотографов по рейтингу
    const topPhotographersByRating = await User.find({ role: "photographer" })
      .sort({ rating: -1, reviewsCount: -1 })
      .limit(5)
      .select("fullName email rating reviewsCount");

    // Динамика заказов по месяцам (последние 6 месяцев)
    const sixMonthsAgo = new Date();
    sixMonthsAgo.setMonth(sixMonthsAgo.getMonth() - 6);

    const ordersByMonth = await Order.aggregate([
      { $match: { createdAt: { $gte: sixMonthsAgo }, status: { $ne: "cancelled" } } },
      {
        $group: {
          _id: {
            year: { $year: "$createdAt" },
            month: { $month: "$createdAt" },
          },
          count: { $sum: 1 },
          revenue: { $sum: "$price" },
        },
      },
      { $sort: { "_id.year": 1, "_id.month": 1 } },
    ]);

    // Последние заказы
    const recentOrders = await Order.find()
      .sort({ createdAt: -1 })
      .limit(10)
      .populate("clientId photographerId", "name email")
      .select("service status price createdAt");

    // Средний чек
    const avgOrderPrice =
      totalOrders > 0
        ? (totalRevenue[0]?.total || 0) / totalOrders
        : 0;

    // Конверсия статусов (процент завершенных заказов)
    const completedOrders = await Order.countDocuments({ status: "completed" });
    const completionRate = totalOrders > 0 ? (completedOrders / totalOrders) * 100 : 0;

    res.json({
      totalOrders,
      totalRevenue: totalRevenue[0]?.total || 0,
      avgOrderPrice: Math.round(avgOrderPrice),
      completionRate: Math.round(completionRate * 10) / 10,
      userStats: userStats.reduce((acc, curr) => {
        acc[curr._id] = curr.count;
        return acc;
      }, {}),
      ordersByStatus: ordersByStatus.reduce((acc, curr) => {
        acc[curr._id] = curr.count;
        return acc;
      }, {}),
      topPhotographersByOrders,
      topPhotographersByRating,
      ordersByMonth: ordersByMonth.map((item) => ({
        month: `${item._id.year}-${String(item._id.month).padStart(2, "0")}`,
        count: item.count,
        revenue: item.revenue,
      })),
      recentOrders,
    });
  } catch (err) {
    console.error("Ошибка при получении статистики:", err);
    res.status(500).json({ error: err.message });
  }
};

// Получить детальную статистику с фильтрами
exports.getStatistics = async (req, res) => {
  try {
    const { startDate, endDate, status, photographerId } = req.query;
    const filter = {};

    // Фильтр по датам (опциональный)
    if (startDate || endDate) {
      filter.createdAt = {};
      if (startDate) filter.createdAt.$gte = new Date(startDate);
      if (endDate) filter.createdAt.$lte = new Date(endDate);
    }

    // Фильтр по статусу
    if (status) filter.status = status;

    // Фильтр по фотографу
    if (photographerId) filter.photographerId = photographerId;

    const orders = await Order.find(filter)
      .populate("clientId photographerId", "name email")
      .sort({ createdAt: -1 });

    const totalRevenue = orders.reduce((sum, o) => sum + o.price, 0);
    const totalOrders = orders.length;
    const avgPrice = totalOrders > 0 ? totalRevenue / totalOrders : 0;

    res.json({
      totalRevenue,
      totalOrders,
      avgPrice: Math.round(avgPrice),
      orders,
    });
  } catch (err) {
    console.error("Ошибка при получении статистики:", err);
    res.status(500).json({ error: err.message });
  }
};

exports.exportPDF = async (req, res) => {
  try {
    const { startDate, endDate, status } = req.query;
    const filter = {};

    if (startDate || endDate) {
      filter.createdAt = {};
      if (startDate) filter.createdAt.$gte = new Date(startDate);
      if (endDate) filter.createdAt.$lte = new Date(endDate);
    }
    if (status) filter.status = status;

    const orders = await Order.find(filter)
      .populate("clientId photographerId", "name email phone")
      .sort({ createdAt: -1 });

    const pdfBuffer = await generatePDF(orders);
    res.setHeader("Content-Type", "application/pdf");
    res.setHeader(
      "Content-Disposition",
      `attachment; filename="orders-report-${Date.now()}.pdf"`
    );
    res.send(pdfBuffer);
  } catch (err) {
    console.error("Ошибка при экспорте PDF:", err);
    res.status(500).json({ error: err.message });
  }
};

exports.exportCSV = async (req, res) => {
  try {
    const { startDate, endDate, status } = req.query;
    const filter = {};

    if (startDate || endDate) {
      filter.createdAt = {};
      if (startDate) filter.createdAt.$gte = new Date(startDate);
      if (endDate) filter.createdAt.$lte = new Date(endDate);
    }
    if (status) filter.status = status;

    const orders = await Order.find(filter)
      .populate("clientId photographerId", "name email phone")
      .sort({ createdAt: -1 });

    const csv = await generateCSV(orders);
    res.setHeader("Content-Type", "text/csv; charset=utf-8");
    res.setHeader(
      "Content-Disposition",
      `attachment; filename="orders-report-${Date.now()}.csv"`
    );
    res.send(csv);
  } catch (err) {
    console.error("Ошибка при экспорте CSV:", err);
    res.status(500).json({ error: err.message });
  }
};

// Расчет выплат фотографам за выбранный период
exports.getPhotographerPayments = async (req, res) => {
  try {
    const { startDate, endDate, percentage = 70 } = req.query;
    const filter = {
      status: "completed", // Только завершенные заказы
      photographerId: { $ne: null }, // Только заказы с назначенным фотографом
    };

    // Фильтр по датам
    if (startDate || endDate) {
      filter.createdAt = {};
      if (startDate) filter.createdAt.$gte = new Date(startDate);
      if (endDate) filter.createdAt.$lte = new Date(endDate);
    }

    // Агрегация выплат по фотографам
    const payments = await Order.aggregate([
      { $match: filter },
      {
        $group: {
          _id: "$photographerId",
          totalOrders: { $sum: 1 },
          totalRevenue: { $sum: "$price" },
        },
      },
      {
        $lookup: {
          from: "users",
          localField: "_id",
          foreignField: "_id",
          as: "photographer",
        },
      },
      { $unwind: "$photographer" },
      {
        $project: {
          photographerId: "$_id",
          name: "$photographer.fullName",
          email: "$photographer.email",
          phone: "$photographer.phoneNumber",
          totalOrders: 1,
          totalRevenue: 1,
          payment: {
            $round: [
              { $multiply: ["$totalRevenue", parseFloat(percentage) / 100] },
              2,
            ],
          },
        },
      },
      { $sort: { totalRevenue: -1 } },
    ]);

    const summary = {
      totalPhotographers: payments.length,
      totalRevenue: payments.reduce((sum, p) => sum + p.totalRevenue, 0),
      totalPayments: payments.reduce((sum, p) => sum + p.payment, 0),
      percentage: parseFloat(percentage),
    };

    res.json({
      summary,
      payments,
    });
  } catch (err) {
    console.error("Ошибка при расчете выплат:", err);
    res.status(500).json({ error: err.message });
  }
};
