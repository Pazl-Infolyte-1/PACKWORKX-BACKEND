import { Request, Response, NextFunction } from "express";

interface CustomRequest extends Request {
    user?: {
        id: number;
        company?: {
            name: string;
        };
    };
}
import { AppDataSource } from '../../../config/data-source'; // Adjust path as necessary
import { User } from '../models/user.model'; // Adjust path as necessary
import { Company } from "../../company/models/company.model"; // Import your Company entity
import Joi from "joi";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import { CONNREFUSED } from "dns";


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
        if(foundUser.status === 'inactive') {
            res.status(400).json({
                status: false,
                message: 'Your account is inactive',
                data: [],
            });
            return;
        }
        if(foundUser.login === 'disable') {
            res.status(400).json({
                status: false,
                message: 'Your account is disabled',
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
                    if ((req as CustomRequest).user) {
                        console.log((req as CustomRequest).user?.id);
                    } else {
                        console.log('User is undefined');
                    }
                    if ((req as CustomRequest).user?.company) {
                        console.log((req as CustomRequest).user?.company?.name);
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
