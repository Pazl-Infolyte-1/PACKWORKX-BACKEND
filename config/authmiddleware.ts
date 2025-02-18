import { Request, Response, NextFunction } from 'express';

interface CustomRequest extends Request {
    user?: any;
}
import jwt, { JwtPayload } from 'jsonwebtoken';
import dotenv from 'dotenv';
import { AppDataSource } from '../config/data-source';
import { User } from '../services/user/models/user.model';

// export const authenticateToken = async (req: CustomRequest, res: Response, next: NextFunction) => {
const SECRET_KEY = process.env.JWT_SECRET_KEY as string || '4f2d568028b66085bb347d8db0f5d20fc3b6079cbeeaee39225c13a23f9b62ab1ef9e6d672e430ed9d37e16b502f32c7b94b1d7f8d3f5c988342de799c9db6b5';

// Authenticate Token Middleware
export const authenticateToken = async (req: CustomRequest, res: Response, next: NextFunction) => {
    console.log('Request Path:', req.path);

    const protectedPaths: string[] = [
        `/${process.env.FOLDER_NAME}/company`,
        `/${process.env.FOLDER_NAME}/user/register`,
        `/${process.env.FOLDER_NAME}/user/login`,
        `/${process.env.FOLDER_NAME}/module`,
        `/${process.env.FOLDER_NAME}/sub-module`,
        `/${process.env.FOLDER_NAME}/refresh-token`,

    ];

    // Skip authentication for unprotected routes like `/docs`
    if (req.path.startsWith(`/${process.env.FOLDER_NAME}/docs`)) {
        return next();
    }

    // Check if the request path starts with any protected path (handles dynamic IDs)
    if (!protectedPaths.some(path => req.path.startsWith(path))) {
        const token = req.header('Authorization')?.split(' ')[1];

        if (!token) {
            return res.status(403).json({
                status: false,
                message: 'Token not provided',
                data: [],
            });
        }

        try {
            const decoded = jwt.verify(token, SECRET_KEY) as JwtPayload;
            const userRepository = AppDataSource.getRepository(User);
            console.log('Decoded:', decoded);
            const userDetails = await userRepository.findOne({
                where: { id: decoded.id },
                relations: ['company']
            });
            console.log('User Details:', userDetails);
            if (!userDetails) {
                return res.status(404).json({
                    status: false,
                    message: 'Unauthorized User',
                    data: [],
                });
            }

            req.user = userDetails;

           
            if (!userDetails.company) {
                return res.status(403).json(
                    {
                        status: false,
                        message: 'Unauthorized: No associated company',
                        data: [],
                    });
            }

            next();
        } catch (err: any) {
            return res.status(err.name === 'TokenExpiredError' ? 401 : 403).json({
                status: false,
                message: err.message,
                data: [],
            });
        }
    } else {
        next();
    }
};
