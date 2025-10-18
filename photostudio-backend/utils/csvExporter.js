const createCsvWriter = require("csv-writer").createObjectCsvWriter;
const path = require("path");
const fs = require("fs");

exports.generateCSV = async (orders) => {
  const filePath = path.join(__dirname, "orders.csv");
  const csvWriter = createCsvWriter({
    path: filePath,
    header: [
      { id: "id", title: "ID" },
      { id: "client", title: "Client" },
      { id: "service", title: "Service" },
      { id: "price", title: "Price" },
      { id: "status", title: "Status" },
    ],
  });

  const records = orders.map((o) => ({
    id: o._id,
    client: o.clientId.name,
    service: o.service,
    price: o.price,
    status: o.status,
  }));

  await csvWriter.writeRecords(records);
  const csv = fs.readFileSync(filePath, "utf8");
  fs.unlinkSync(filePath);
  return csv;
};
