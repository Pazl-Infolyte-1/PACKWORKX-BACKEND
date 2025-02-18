
import express from "express";
import cors from "cors"; // Corrected import statement for cors
import swaggerUi from 'swagger-ui-express';
import path from 'path';
import swaggerJSDoc, { Options } from 'swagger-jsdoc'; // Corrected import statement for authenticateToken
import * as dotenv from 'dotenv';
const app = express();
const PORT = 3000;
const serviceName = 'docs'
app.use(express.json());
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
        url: 'https://packworkx.pazl.info',
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
    path.join(__dirname, "./controllers", "*.{js,ts}")  // Converts to absolute path

  ],
};

// Initialize swagger-jsdoc
const swaggerSpec = swaggerJSDoc(swaggerOptions);

// Serve Swagger UI
const swaggerPath = express.static(path.join(__dirname, '../../public/swagger-custom.js'));
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
app.listen(PORT, '0.0.0.0', () => {
  console.log(`${serviceName} Service running on port ${PORT}`);
});