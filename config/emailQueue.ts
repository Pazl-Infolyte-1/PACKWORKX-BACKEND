import nodemailer from 'nodemailer';
import dotenv from 'dotenv';

dotenv.config();

// Define an interface for email job data
interface EmailJob {
    to: string;
    subject: string;
    text: string;
}

// Configure Nodemailer
const transporter = nodemailer.createTransport({
    host: 'smtp.gmail.com',
    port: 587,
    secure: false, // Use STARTTLS
    auth: {
        user: process.env.EMAIL_USER_NAME,
        pass: process.env.EMAIL_PASSWORD,
    },
});

/**
 * Function to send an email
 * @param job Email job containing recipient, subject, and text
 */
export const sendEmail = async (job: EmailJob): Promise<void> => {
    const mailOptions = {
        from: process.env.EMAIL_FROM,
        to: job.to,
        subject: job.subject,
        text: job.text,
    };

    try {
        const info = await transporter.sendMail(mailOptions);
        console.log('Email sent:', info.response);
    } catch (error) {
        console.error('Failed to send email:', error);
    }
};