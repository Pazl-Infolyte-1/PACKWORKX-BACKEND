import express from "express";
import cors from "cors"; // Corrected import statement for cors
import { AppDataSource } from "../../config/data-source";
import userroutes from "./routes/user.routes";
import * as dotenv from 'dotenv';
import { authenticateToken } from "../../config/authmiddleware";
// import { User } from '../../services/user/controllers/user.controller'; // Import your entities explicitly
import swaggerUi from 'swagger-ui-express';
import path from 'path';
import swaggerJSDoc, { Options } from 'swagger-jsdoc'; // Corrected import statement for authenticateToken
const app = express();
const PORT = 3001;
app.use(cors());
app.use(express.json());
dotenv.config();
app.use(cors());
app.use(
  cors({
    origin: process.env.BASE_URL,
    methods: ['GET', 'POST'],
    allowedHeaders: ['Content-Type', 'Authorization'],
  })
);
// Initialize TypeORM connection
AppDataSource.initialize()
  .then(() => {
    console.log("User : Data Source has been initialized!");
  })
  .catch((error) => console.log("Error during User Data Source initialization:", error));

// Use routes

app.use(authenticateToken);
app.use(`/${process.env.FOLDER_NAME}`, userroutes);
const swaggerOptions: Options = {
  swaggerDefinition: {
    openapi: '3.0.0',
    info: {
      title: 'Pacx Works API',
      version: '1.0.0',
      description: 'API for managing Pacx Works',
      contact: {
        name: 'Ananda Karthick',
        email: 'ananda.s@pazl.info',
      },
    },
    servers: [
      {
        url: `${process.env.BASE_URL}:${PORT}` || 'https://buzz.pazl.info',
        description: 'Server',
      },
    ],
    components: {
      securitySchemes: {
        bearerAuth: {
          type: 'http',
          scheme: 'bearer',
          bearerFormat: 'JWT',
        },
      },
    },
    security: [
      {
        bearerAuth: [],
      },
    ],
  },
  apis: [
    './services/user/controllers/*.ts',
    './services/company/controllers/*.ts'   // Path to microservice2 controllers
  ],
};

// Initialize swagger-jsdoc
const swaggerSpec = swaggerJSDoc(swaggerOptions);

// Serve Swagger UI
const swaggerPath=express.static(path.join(__dirname, '../../public/swagger-custom.js'));
app.use(
  `/${process.env.FOLDER_NAME}/docs`,
  swaggerUi.serve,
  swaggerUi.setup(swaggerSpec, {
    customSiteTitle: 'Pacx Works API',
    customCss: '.swagger-ui .topbar { background-color: #1B9C85; }',
    // customJs: '../../public/swagger-custom.js', // Add this line
  })
);

// Serve the custom JavaScript file
app.use('/swagger-custom.js', express.static(path.join(__dirname, '../../public/swagger-custom.js')));

// const PORT = 3001;
// app.listen(PORT, () => {
//   console.log(`User Service running on port ${PORT}`);
//   // console.log(path.join(__dirname, '../../public/swagger-custom.js'))
// });
app.listen(PORT, '0.0.0.0',() => {
  console.log(`User Service running on port ${PORT}`);
});

