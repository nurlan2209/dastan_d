const Schedule = require("../models/Schedule");

exports.createSchedule = async (req, res) => {
  try {
    const schedule = await Schedule.create({
      ...req.body,
      photographerId: req.user.id,
    });
    res.status(201).json(schedule);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getSchedule = async (req, res) => {
  try {
    const photographerId = req.query.photographerId || req.user.id;
    const schedule = await Schedule.find({ photographerId });
    res.json(schedule);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.updateSchedule = async (req, res) => {
  try {
    const schedule = await Schedule.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
    });
    res.json(schedule);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.deleteSchedule = async (req, res) => {
  try {
    await Schedule.findByIdAndDelete(req.params.id);
    res.json({ message: "Schedule deleted" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
