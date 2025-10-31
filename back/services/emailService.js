const nodemailer = require("nodemailer");

// Создание транспорта для отправки писем
const createTransporter = () => {
  return nodemailer.createTransport({
    host: process.env.SMTP_HOST,
    port: parseInt(process.env.SMTP_PORT || "587"),
    secure: process.env.SMTP_SECURE === "true", // true для 465, false для других портов
    auth: {
      user: process.env.SMTP_USER,
      pass: process.env.SMTP_PASSWORD,
    },
  });
};

// Генерация 6-значного кода
const generateVerificationCode = () => {
  return Math.floor(100000 + Math.random() * 900000).toString();
};

// Отправка кода подтверждения email
const sendVerificationEmail = async (email, code) => {
  const transporter = createTransporter();

  const mailOptions = {
    from: `"${process.env.SMTP_FROM_NAME || 'Photo Studio'}" <${process.env.SMTP_USER}>`,
    to: email,
    subject: "Подтверждение регистрации",
    html: `
      <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
        <h2 style="color: #333;">Подтверждение регистрации</h2>
        <p>Здравствуйте!</p>
        <p>Ваш код подтверждения:</p>
        <div style="background-color: #f5f5f5; padding: 20px; text-align: center; font-size: 32px; font-weight: bold; letter-spacing: 5px; margin: 20px 0;">
          ${code}
        </div>
        <p>Код действителен в течение 5 минут.</p>
        <p style="color: #666; font-size: 14px;">Если вы не регистрировались на нашем сайте, проигнорируйте это письмо.</p>
      </div>
    `,
  };

  await transporter.sendMail(mailOptions);
};

// Отправка кода для сброса пароля
const sendPasswordResetEmail = async (email, code) => {
  const transporter = createTransporter();

  const mailOptions = {
    from: `"${process.env.SMTP_FROM_NAME || 'Photo Studio'}" <${process.env.SMTP_USER}>`,
    to: email,
    subject: "Сброс пароля",
    html: `
      <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
        <h2 style="color: #333;">Сброс пароля</h2>
        <p>Здравствуйте!</p>
        <p>Вы запросили сброс пароля. Ваш код подтверждения:</p>
        <div style="background-color: #f5f5f5; padding: 20px; text-align: center; font-size: 32px; font-weight: bold; letter-spacing: 5px; margin: 20px 0;">
          ${code}
        </div>
        <p>Код действителен в течение 5 минут.</p>
        <p style="color: #666; font-size: 14px;">Если вы не запрашивали сброс пароля, проигнорируйте это письмо.</p>
      </div>
    `,
  };

  await transporter.sendMail(mailOptions);
};

module.exports = {
  generateVerificationCode,
  sendVerificationEmail,
  sendPasswordResetEmail,
};
