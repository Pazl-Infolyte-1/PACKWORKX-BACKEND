import 'reflect-metadata';
import { DataSource } from 'typeorm';
import * as dotenv from 'dotenv';
import { Company } from '../services/company/models/company.model'; 
import { User } from '../services/user/models/user.model';
import { Module } from '../services/module/models/module.model';
import { ModuleGroup } from '../services/module/models/module_group.model';
import { ModuleIcon } from '../services/module/models/module_icon.model';
import { SubModule } from '../services/module/models/sub_module.model';
import { ApiLog } from '../services/user/models/apilogs.model'; // Import your entities explicitly

dotenv.config();

export const AppDataSource = new DataSource({
    type: 'mysql',
    host: process.env.DB_HOST,
    port: Number(process.env.DB_PORT) || 3306,
    username: process.env.DB_USER,
    password: process.env.DB_PASS,
    database: process.env.DB_NAME,
    migrations: [__dirname + '/migration/**/*.ts'],  // Correct path for migrations
    entities: [
        Company,
        User,
        ApiLog,
        Module,
        ModuleGroup,
        ModuleIcon,
        SubModule,


    ],
    // synchronize: true,  // Avoid in production; helpful for dev environments
    logging: false,
});
