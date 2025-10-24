const PDFDocument = require("pdfkit");

exports.generatePDF = (orders) => {
  return new Promise((resolve) => {
    const doc = new PDFDocument();
    const buffers = [];

    doc.on("data", buffers.push.bind(buffers));
    doc.on("end", () => resolve(Buffer.concat(buffers)));

    doc.fontSize(20).text("Orders Report", { align: "center" });
    doc.moveDown();

    orders.forEach((order) => {
      doc.fontSize(12).text(`Order ID: ${order._id}`);
      doc.text(`Client: ${order.clientId.name}`);
      doc.text(`Service: ${order.service}`);
      doc.text(`Price: ${order.price}`);
      doc.text(`Status: ${order.status}`);
      doc.moveDown();
    });

    doc.end();
  });
};
