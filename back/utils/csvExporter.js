const createCsvWriter = require("csv-writer").createObjectCsvWriter;
const path = require("path");
const fs = require("fs");

exports.generateCSV = async (orders) => {
  const filePath = path.join(__dirname, `orders-${Date.now()}.csv`);

  const statusTranslate = {
    new: "Новый",
    assigned: "Назначен",
    in_progress: "В работе",
    completed: "Завершен",
    cancelled: "Отменен",
    archived: "Архив",
  };

  const csvWriter = createCsvWriter({
    path: filePath,
    header: [
      { id: "num", title: "№" },
      { id: "orderId", title: "ID заказа" },
      { id: "date", title: "Дата съемки" },
      { id: "createdAt", title: "Дата создания" },
      { id: "client", title: "Клиент" },
      { id: "clientEmail", title: "Email клиента" },
      { id: "clientPhone", title: "Телефон клиента" },
      { id: "photographer", title: "Фотограф" },
      { id: "photographerEmail", title: "Email фотографа" },
      { id: "photographerPhone", title: "Телефон фотографа" },
      { id: "service", title: "Услуга" },
      { id: "location", title: "Локация" },
      { id: "price", title: "Цена (тг)" },
      { id: "status", title: "Статус" },
      { id: "comment", title: "Комментарий" },
    ],
    fieldDelimiter: ";", // Точка с запятой для Excel
    encoding: "utf8",
  });

  const records = orders.map((o, index) => ({
    num: index + 1,
    orderId: o._id?.toString() || "",
    date: o.date ? new Date(o.date).toLocaleDateString("ru-RU") : "",
    createdAt: o.createdAt
      ? new Date(o.createdAt).toLocaleDateString("ru-RU")
      : "",
    client: o.clientId?.fullName || "—",
    clientEmail: o.clientId?.email || "—",
    clientPhone: o.clientId?.phoneNumber || "—",
    photographer: o.photographerId?.fullName || "Не назначен",
    photographerEmail: o.photographerId?.email || "—",
    photographerPhone: o.photographerId?.phoneNumber || "—",
    service: o.service || "—",
    location: o.location || "—",
    price: o.price || 0,
    status: statusTranslate[o.status] || o.status || "—",
    comment: o.comment || "",
  }));

  await csvWriter.writeRecords(records);

  // Читаем CSV и добавляем BOM для корректного отображения в Excel
  let csv = fs.readFileSync(filePath, "utf8");
  const BOM = "\uFEFF";
  csv = BOM + csv;

  // Удаляем временный файл
  fs.unlinkSync(filePath);

  return csv;
};
