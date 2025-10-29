const PDFDocument = require("pdfkit");
const path = require("path");
const fs = require("fs");

exports.generatePDF = (orders) => {
  return new Promise((resolve, reject) => {
    try {
      const doc = new PDFDocument({ margin: 50, size: "A4" });
      const buffers = [];

      doc.on("data", buffers.push.bind(buffers));
      doc.on("end", () => resolve(Buffer.concat(buffers)));
      doc.on("error", reject);

      // Try to load Cyrillic font
      const fontPath = path.join(__dirname, "../fonts/Roboto-Regular.ttf");
      let useCustomFont = false;

      try {
        if (fs.existsSync(fontPath)) {
          doc.registerFont("Roboto", fontPath);
          useCustomFont = true;
        } else {
          console.warn("Warning: Roboto font not found. PDF will use transliteration.");
          console.warn("To fix: Add Roboto-Regular.ttf to back/fonts/");
          console.warn("Download: https://fonts.google.com/specimen/Roboto");
        }
      } catch (fontError) {
        console.warn("Font loading error:", fontError.message);
      }

      const regularFont = useCustomFont ? "Roboto" : "Helvetica";
      const boldFont = useCustomFont ? "Roboto" : "Helvetica-Bold";

      // Заголовок
      doc
        .fontSize(24)
        .font(boldFont)
        .text("Otchet po zakazam", { align: "center" });

      doc.moveDown(0.5);

      // Дата генерации
      doc
        .fontSize(10)
        .font(regularFont)
        .text(
          `Data formirovaniya: ${new Date().toLocaleDateString("ru-RU")}`,
          { align: "center" }
        );

      doc.moveDown(1);

      // Сводная информация
      const totalOrders = orders.length;
      const totalRevenue = orders.reduce((sum, o) => sum + (o.price || 0), 0);
      const avgPrice = totalOrders > 0 ? totalRevenue / totalOrders : 0;

      doc
        .fontSize(12)
        .font(boldFont)
        .text("Svodka:", { underline: true });
      doc.moveDown(0.3);
      doc
        .fontSize(11)
        .font(regularFont)
        .text(`Vsego zakazov: ${totalOrders}`)
        .text(`Obshaya vyruchka: ${totalRevenue.toLocaleString("ru-RU")} tg`)
        .text(`Sredniy chek: ${Math.round(avgPrice).toLocaleString("ru-RU")} tg`);

      doc.moveDown(1.5);

      // Таблица заказов
      doc.fontSize(12).font(boldFont).text("Spisok zakazov:");
      doc.moveDown(0.5);

      // Заголовок таблицы
      const tableTop = doc.y;
      const colWidths = {
        num: 30,
        date: 70,
        client: 120,
        photographer: 120,
        service: 100,
        price: 70,
        status: 80,
      };

      let currentY = tableTop;

      // Функция для отрисовки строки таблицы
      const drawRow = (rowData, y, isHeader = false) => {
        const font = isHeader ? boldFont : regularFont;
        const fontSize = isHeader ? 9 : 8;
        doc.font(font).fontSize(fontSize);

        let x = 50;

        // Номер
        doc.text(rowData.num || "", x, y, {
          width: colWidths.num,
          align: "left",
        });
        x += colWidths.num;

        // Дата
        doc.text(rowData.date || "", x, y, {
          width: colWidths.date,
          align: "left",
        });
        x += colWidths.date;

        // Клиент
        doc.text(rowData.client || "", x, y, {
          width: colWidths.client,
          align: "left",
        });
        x += colWidths.client;

        // Фотограф
        doc.text(rowData.photographer || "", x, y, {
          width: colWidths.photographer,
          align: "left",
        });
        x += colWidths.photographer;

        // Услуга
        doc.text(rowData.service || "", x, y, {
          width: colWidths.service,
          align: "left",
        });
        x += colWidths.service;

        // Цена
        doc.text(rowData.price || "", x, y, {
          width: colWidths.price,
          align: "right",
        });
        x += colWidths.price;

        // Статус
        doc.text(rowData.status || "", x, y, {
          width: colWidths.status,
          align: "left",
        });

        return y + (isHeader ? 20 : 15);
      };

      // Заголовок таблицы
      currentY = drawRow(
        {
          num: "#",
          date: "Data",
          client: "Klient",
          photographer: "Fotograf",
          service: "Usluga",
          price: "Tsena",
          status: "Status",
        },
        currentY,
        true
      );

      // Линия под заголовком
      doc
        .moveTo(50, currentY - 5)
        .lineTo(545, currentY - 5)
        .stroke();

      // Переводим статусы на транслит
      const statusTranslate = {
        new: "Novyy",
        assigned: "Naznachen",
        in_progress: "V rabote",
        completed: "Zavershen",
        cancelled: "Otmenen",
        archived: "Arkhiv",
      };

      // Данные заказов
      orders.forEach((order, index) => {
        // Проверка на новую страницу
        if (currentY > 700) {
          doc.addPage();
          currentY = 50;
        }

        const orderDate = order.date
          ? new Date(order.date).toLocaleDateString("ru-RU")
          : "";

        currentY = drawRow(
          {
            num: (index + 1).toString(),
            date: orderDate,
            client: order.clientId?.name || "—",
            photographer: order.photographerId?.name || "—",
            service: order.service || "—",
            price: order.price ? `${order.price} тг` : "—",
            status: statusTranslate[order.status] || order.status || "—",
          },
          currentY,
          false
        );
      });

      // Нижний колонтитул
      const pageCount = doc.bufferedPageRange().count;
      for (let i = 0; i < pageCount; i++) {
        doc.switchToPage(i);
        doc
          .fontSize(8)
          .font(regularFont)
          .text(
            `Stranitsa ${i + 1} iz ${pageCount}`,
            50,
            doc.page.height - 50,
            { align: "center" }
          );
      }

      doc.end();
    } catch (error) {
      reject(error);
    }
  });
};
