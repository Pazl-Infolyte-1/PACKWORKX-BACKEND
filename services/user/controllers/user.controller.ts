import { Request, Response, NextFunction } from "express";
import { AppDataSource } from '../../../config/data-source'; // Adjust path as necessary
import { User } from '../models/user.model'; // Adjust path as necessary
import { Company } from "../../company/models/company.model"; // Import your Company entity
import Joi from "joi";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import { CONNREFUSED } from "dns";


/**
 * @swagger
 * /api/user/login:
 *   post:
 *     summary: Login user and generate a JWT token
 *     description: This endpoint authenticates a user and generates a JWT token for authorized access.
 *     tags: [Users]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - userName
 *               - password
 *             properties:
 *               userName:
 *                 type: string
 *                 description: The user's email address.
 *                 example: user@example.com
 *               password:
 *                 type: string
 *                 description: The user's password.
 *                 example: Password123
 *     responses:
 *       200:
 *         description: Login successful, JWT token generated
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 status:
 *                   type: boolean
 *                   example: true
 *                 message:
 *                   type: string
 *                   example: Login successful
 *                 data:
 *                   type: object
 *                   properties:
 *                     token:
 *                       type: string
 *                       description: JWT token generated for the authenticated user
 *                       example: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNjEyMzQ1NjA1fQ.E0xWyR9TRzyyz1pL9bgpWQ"
 *       400:
 *         description: Invalid credentials or validation error
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 status:
 *                   type: boolean
 *                   example: false
 *                 message:
 *                   type: string
 *                   example: Invalid credentials
 *                 data:
 *                   type: array
 *                   items:
 *                     type: string
 *                   example: []
 *       500:
 *         description: Internal Server Error
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 status:
 *                   type: boolean
 *                   example: false
 *                 message:
 *                   type: string
 *                   example: Internal Server Error
 *                 error:
 *                   type: string
 *                   example: Some error message
 *                 filePath:
 *                   type: string
 *                   example: /path/to/file.ts
 *                 lineNumber:
 *                   type: string
 *                   example: "line 42"
 */
export const login = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
        const UserSchema = Joi.object({
            userName: Joi.string().email().required().messages({
                "string.empty": "Email is required",
                "string.email": "Invalid email format",
                "string.min": "User name must be at least 2 characters",
                "string.max": "User name cannot exceed 255 characters",
            }),
            password: Joi.string().min(6).max(128).required().messages({
                "string.empty": "Password is required",
                "string.min": "Password must be at least 6 characters",
                "string.max": "Password cannot exceed 128 characters",
            }),

        });
        const { error } = UserSchema.validate(req.body, { abortEarly: false });
        if (error) {
            res.status(400).json({
                status: false,
                message: "Validation failed",
                errors: error.details.map((err) => err.message),
            });
            return;
        }
        const UserRepository = AppDataSource.getRepository(User);
        const foundUser = await UserRepository.findOneBy({ email: req.body.email });
        if (!foundUser) {
            res.status(400).json({
                status: false,
                message: 'Invalid credentials',
                data: [],
            });
            return;
        }
        const isMatch = await bcrypt.compare(req.body.password, foundUser.password);
        if (!isMatch) {
            res.status(400).json({
                status: false,
                message: 'Invalid credentials',
                data: [],
            });
            return;
        }
        const token = jwt.sign(
            { id: foundUser.id},
            process.env.JWT_SECRET as string,
            { expiresIn: "1h" }
        );
        res.status(200).json({
            status: true,
            message: 'Login successful',
            data: { token },
        });
    } catch (error) {
        const stackTrace = (error instanceof Error && error.stack) ? error.stack.split("\n")[1].trim() : "Unknown";

        res.status(500).json({
            status: false,
            message: "Internal Server Error",
            error: error instanceof Error ? error.message : "Unknown error",
            filePath: __filename, // Gets current file path
            lineNumber: stackTrace, // Extracts line number from stack trace
        });
    }

}

/**
 * @swagger
 * tags:
 *   - name: Users
 *     description: API for managing users
 */

/**
 * @swagger
 * /api/user/register:
 *   post:
 *     summary: Create a new user
 *     tags: [Users]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - name
 *               - email
 *               - password
 *               - company_id
 *             properties:
 *               name:
 *                 type: string
 *                 minLength: 2
 *                 maxLength: 255
 *                 example: "John Doe"
 *               email:
 *                 type: string
 *                 format: email
 *                 example: "john.doe@example.com"
 *               password:
 *                 type: string
 *                 minLength: 6
 *                 maxLength: 128
 *                 example: "password123"
 *               company_id:
 *                 type: integer
 *                 example: 1
 *     responses:
 *       201:
 *         description: User registered successfully
 *       400:
 *         description: Validation error or email already exists
 *       500:
 *         description: Internal server error
 */

/**
 * @swagger
 * /api/user/{id}:
 *   get:
 *     summary: Get user by ID
 *     tags: [Users]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         example: 1
 *     responses:
 *       200:
 *         description: User fetched successfully
 *       404:
 *         description: User not found
 *       500:
 *         description: Internal server error
 */

/**
 * @swagger
 * /api/user:
 *   get:
 *     summary: Get all users
 *     tags: [Users]
 *     responses:
 *       200:
 *         description: Users fetched successfully
 *       500:
 *         description: Internal server error
 */

/**
 * @swagger
 * /api/user/{id}:
 *   put:
 *     summary: Update user by ID
 *     tags: [Users]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         example: 1
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *                 example: "Updated Name"
 *               email:
 *                 type: string
 *                 format: email
 *                 example: "updated@example.com"
 *     responses:
 *       200:
 *         description: User updated successfully
 *       404:
 *         description: User not found
 *       500:
 *         description: Internal server error
 */

/**
 * @swagger
 * /api/user/{id}:
 *   delete:
 *     summary: Delete user by ID
 *     tags: [Users]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         example: 1
 *     responses:
 *       200:
 *         description: User deactivated successfully
 *       404:
 *         description: User not found
 *       500:
 *         description: Internal server error
 */

export const user = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
        const UserRepository = AppDataSource.getRepository(User);

        switch (req.method) {
            case 'POST': {
                const UserSchema = Joi.object({
                    name: Joi.string().min(2).max(255).required().messages({
                        "string.empty": "User name is required",
                        "string.min": "User name must be at least 2 characters",
                        "string.max": "User name cannot exceed 255 characters",
                    }),
                    password: Joi.string().min(6).max(128).required().messages({
                        "string.empty": "Password is required",
                        "string.min": "Password must be at least 6 characters",
                        "string.max": "Password cannot exceed 128 characters",
                    }),
                    email: Joi.string().email().required().messages({
                        "string.empty": "Email is required",
                        "string.email": "Invalid email format",
                        "string.min": "User name must be at least 2 characters",
                        "string.max": "User name cannot exceed 255 characters",
                    }),
                    company_id: Joi.number().integer().required().messages({
                        "number.base": "Company Id must be a number",
                        "number.integer": "Company Id must be an integer",
                        "any.required": "Company Id is required",
                    }),
                });
                const { error } = UserSchema.validate(req.body, { abortEarly: false });
                if (error) {
                    res.status(400).json({
                        status: false,
                        message: "Validation failed",
                        errors: error.details.map((err) => err.message),
                    });
                    return;
                }
                const UserRepository = AppDataSource.getRepository(User);
                const existingEmail = await UserRepository.findOne({
                    where: {
                        email: req.body.email,
                        // company: { id: req.body.company_id }, // Use the related company object with its id
                    },
                });
                if (existingEmail) {
                    res.status(400).json({
                        status: true,
                        message: 'Email already exists',
                        data: [],
                    });
                    return;
                }
                const { name, email, password } = req.body;
                const hashedPassword = await bcrypt.hash(password, 10);
                const CompanyRepository = AppDataSource.getRepository(Company);
                const company = await CompanyRepository.findOne({ where: { id: req.body.company_id } });

                if (!company) {
                    throw new Error('Company not found');
                }

                // Then create the new user with the company association
                const newUser = UserRepository.create({
                    name,
                    email,
                    password: hashedPassword,
                    company: company,  // Associate the company directly
                });

                await UserRepository.save(newUser);
                res.status(201).json({
                    status: true,
                    message: 'User registered successfully',
                    data: newUser,
                });
                break;
            }

            case 'GET': {
                if (req.params.id) {
                    // Fetch a single User by ID
                    if (req.user) {
                        console.log(req.user.id);
                    } else {
                        console.log('User is undefined');
                    }
                    if (req.user?.company) {
                        console.log(req.user.company.name);
                    } else {
                        console.log('company is undefined');
                    }
                    // console.log(req.company); // Removed because 'company' does not exist on 'Request'
                    const User = await UserRepository.findOneBy({ id: Number(req.params.id) });
                    if (!User) {
                        res.status(404).json({
                            status: true,
                            message: 'User not found',
                            data: [],
                        });
                        return;
                    }
                    res.status(200).json({
                        status: true,
                        message: 'User fetch successfully',
                        data: User,  // ✅ Corrected: Sending an array instead of an undefined `item`
                    });
                } else {
                    // Fetch all companies from the database
                    const companies = await UserRepository.find();
                    res.status(200).json({
                        status: true,
                        message: 'User fetch successfully',
                        data: companies,  // ✅ Corrected: Sending an array instead of an undefined `item`
                    });
                }
                break;
            }

            case 'PUT': {
                const User = await UserRepository.findOneBy({ id: Number(req.params.id) });
                if (!User) {
                    res.status(404).json({
                        status: true,
                        message: 'User not found',
                        data: [],
                    });
                    return;
                }

                // Merge and update the User
                UserRepository.merge(User, req.body);
                await UserRepository.save(User);

                res.status(200).json({
                    status: true,
                    message: 'User fetch successfully',
                    data: User,  // ✅ Corrected: Sending an array instead of an undefined `item`
                });
                break;
            }

            case 'DELETE': {
                const User = await UserRepository.findOneBy({ id: Number(req.params.id) });
                if (!User) {
                    res.status(404).json({
                        status: true,
                        message: 'User not found',
                        data: [],
                    });
                    return;
                }

                // Remove the User
                await UserRepository.remove(User);
                res.status(200).json({
                    status: true,
                    message: 'User Deactivated successfully',
                    data: [],
                });

                break;
            }

            default:
                res.status(405).json({
                    status: true,
                    message: 'Method not allowed',
                    data: [],
                });
                break;
        }
    } catch (error) {
        next(error);
    }
};
