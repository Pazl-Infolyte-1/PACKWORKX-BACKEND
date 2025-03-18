
import express from "express";
import cors from "cors"; // Corrected import statement for cors
import { AppDataSource } from "../../config/data-source";
import companyRoutes from "./routes/company.routes";
import * as dotenv from 'dotenv';
import { authenticateToken } from "../../config/authmiddleware";
const app = express();
const PORT = 4001;
const serviceName = 'Company'
app.use(express.json());
dotenv.config();
const allowedOrigins = [
  "http://localhost:3000",
  "https://tvs.in"
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
app.use(`/${process.env.FOLDER_NAME}`, companyRoutes);
app.listen(PORT, '0.0.0.0', () => {
  console.log(`${serviceName} Service running on port ${PORT}`);
});

