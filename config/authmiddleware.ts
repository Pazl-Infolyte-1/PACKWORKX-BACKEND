import { Request, Response, NextFunction } from 'express'; // Import express types

// Extend the Request interface to include the user property
declare module 'express-serve-static-core' {
    interface Request {
        user?: User;
    }
}
import jwt, { JwtPayload } from 'jsonwebtoken'; // Import jsonwebtoken with types
import dotenv from 'dotenv';  // Use `require('dotenv').config()` for CommonJS syntax
import { AppDataSource } from '../config/data-source'; // Adjust path as necessary
import { User } from '../services/user/models/user.model';  // Import the User model (ensure path is correct)

dotenv.config();
const SECRET_KEY = process.env.JWT_SECRET_KEY as string;  // Ensure SECRET_KEY is treated as a string

// Define Payload interface if necessary, depending on what data is in the token
interface Payload {
    userId: number;
    email: string;
    // Add any other properties in the payload
}

// Generate JWT token
export const generateToken = (payload: Payload): string => {
    return jwt.sign(payload, SECRET_KEY, { algorithm: 'HS256' });
};

// Authenticate Token Middleware
export const authenticateToken = (req: Request, res: Response, next: NextFunction): void => {
    console.log("Image Path in authenticateToken:" + req.path);
    console.log('Request Path:', req.path);

    const protectedPaths: string[] = [
        `/${process.env.FOLDER_NAME}/company`,
        `/${process.env.FOLDER_NAME}/user/register`,
        `/${process.env.FOLDER_NAME}/user/login`
    ];

    // If the requested path is not protected, skip token validation
    if (!protectedPaths.includes(req.path) && !req.path.startsWith(`/${process.env.FOLDER_NAME}/docs`)) {
        const token = req.header('Authorization')?.split(' ')[1]; // Get the token from header
        
        if (!token) {
            res.status(403).json({ message: 'Token is missing' });
        }

        if (!token) {
             res.status(403).json({ message: 'Token is missing' });
        }

        jwt.verify(token as string, process.env.JWT_SECRET as string, async (err: jwt.VerifyErrors | null, decodedToken) => { // Decode the token
            if (err) {
                if (err.name === 'TokenExpiredError') {
                    return res.status(401).json({ message: 'Token has expired' });
                } else {
                    return res.status(403).json({ message: 'Invalid token' });
                }
            }

            const decoded = decodedToken as JwtPayload;
            const userRepository = AppDataSource.getRepository(User);
            const userDetails = await userRepository.findOne({ 
                where: { id: decoded.userId }, 
                relations: ['company']  // Ensure 'company' is loaded
            });
            if (!userDetails) {
                return res.status(404).json({ message: 'User not found' });
            }

            req.user = userDetails; // Attach the user object (decoded token) to the request

            next(); // Continue to the next middleware or route handler
        });
    } else {
        next();
    }
};
