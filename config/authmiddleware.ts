import { Request, Response, NextFunction } from 'express';

interface CustomRequest extends Request {
    user?: any;
}
import jwt, { JwtPayload } from 'jsonwebtoken';
import dotenv from 'dotenv';
import { AppDataSource } from '../config/data-source';
import { User } from '../services/user/models/user.model';

// export const authenticateToken = async (req: CustomRequest, res: Response, next: NextFunction) => {
const SECRET_KEY = process.env.JWT_SECRET_KEY as string;

// Authenticate Token Middleware
export const authenticateToken = async (req: CustomRequest, res: Response, next: NextFunction) => {
    console.log('Request Path:', req.path);

    const protectedPaths: string[] = [
        `/${process.env.FOLDER_NAME}/company`,
        `/${process.env.FOLDER_NAME}/user/register`,
        `/${process.env.FOLDER_NAME}/user/login`,
        `/${process.env.FOLDER_NAME}/module`
    ];

    // Skip authentication for unprotected routes like `/docs`
    if (req.path.startsWith(`/${process.env.FOLDER_NAME}/docs`)) {
        return next();
    }

    // Check if the request path starts with any protected path (handles dynamic IDs)
    if (!protectedPaths.some(path => req.path.startsWith(path))) {
        const token = req.header('Authorization')?.split(' ')[1]; 

        if (!token) {
            return res.status(403).json({ message: 'Token is missing' });
        }

        try {
            const decoded = jwt.verify(token, SECRET_KEY) as JwtPayload;
            const userRepository = AppDataSource.getRepository(User);
            const userDetails = await userRepository.findOne({
                where: { id: decoded.userId },
                relations: ['company']
            });

            if (!userDetails) {
                return res.status(404).json({ message: 'User not found' });
            }

            req.user = userDetails;

            // Allow Super Admins to bypass company validation
            if (userDetails.role === 'super_admin') {
                return next();
            }

            if (!userDetails.company) {
                return res.status(403).json({ message: 'Unauthorized: No associated company' });
            }

            next();
        } catch (err: any) {
            return res.status(err.name === 'TokenExpiredError' ? 401 : 403).json({ message: err.message });
        }
    } else {
        next();
    }
};
