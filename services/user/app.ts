
import express from "express";
import cors from "cors"; // Corrected import statement for cors
import { AppDataSource } from "../../config/data-source";
import userRoutes from "./routes/user.routes";
import * as dotenv from 'dotenv';
import { authenticateToken } from "../../config/authmiddleware";
import { requestEncodeResponseDecode } from "../../config/requestEncodeResponseDecode";
import { ApiLogRequestResponse } from "../../config/log.middleware";
const app = express();
const PORT = 3002;
const serviceName = 'User'
app.use(cors());
app.use(express.json());
// app.use(requestEncodeResponseDecode);
dotenv.config();
const allowedOrigins = [
  "http://localhost:3000",
  "https://packworkx.pazl.info"
];
app.use(
  cors({
    origin: function (origin, callback) {
      if (!origin || allowedOrigins.includes(origin)) {
        callback(null, true); // Allow request
      } else {
        callback(new Error("Not allowed by CORS")); // Block request
      }
    },
    methods: "GET,POST,PUT,DELETE",
    credentials: true
  })
);
// Initialize TypeORM connection
console.log(`${serviceName} : working!`);
AppDataSource.initialize()
  .then(() => {
    console.log(`${serviceName} : Data Source has been initialized!`);
  })
  .catch((error) => console.log(`Error during ${serviceName} Data Source initialization:`, error));
app.use(authenticateToken as express.RequestHandler);
app.use(ApiLogRequestResponse);
app.use(`/${process.env.FOLDER_NAME}`, userRoutes);
app.listen(PORT, '0.0.0.0', () => {
  console.log(`${serviceName} Service running on port ${PORT}`);
});

