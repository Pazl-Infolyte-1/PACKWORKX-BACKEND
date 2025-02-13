import { Request, Response, NextFunction } from "express";
import { AppDataSource } from '../../../config/data-source'; // Adjust path as necessary
import { Module } from '../models/module.model'; // Adjust path as necessary
import Joi from "joi";

export const modules = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
        const ModuleRepository = AppDataSource.getRepository(Module);

        switch (req.method) {
            case 'POST': {
                const moduleSchema = Joi.object({
                    moduleName: Joi.string().min(2).max(255).required().messages({
                        "string.empty": "Module name is required",
                        "string.min": "Module name must be at least 2 characters",
                        "string.max": "Module name cannot exceed 255 characters",
                    }),
                    description: Joi.string().min(2).max(255).required().messages({
                        "string.empty": "Description is required",
                        "string.min": "Description must be at least 2 characters",
                        "string.max": "Description cannot exceed 255 characters",
                    }),
                    icon: Joi.string().min(2).max(255).required().messages({
                        "string.empty": "Icon is required",
                        "string.min": "Icon must be at least 2 characters",
                        "string.max": "Icon cannot exceed 255 characters",
                    }),
                    parentId: Joi.number().integer().allow(null).optional(),
                    companyId: Joi.number().integer().min(1).required().messages({
                        "number.empty": "Company Id is required",
                        "number.min": "Company Id must be at least 1",
                    }),
                });

                const { error } = moduleSchema.validate(req.body, { abortEarly: false });
                if (error) {
                    res.status(400).json({
                        status: false,
                        message: "Validation failed",
                        errors: error.details.map((err) => err.message),
                    });
                    return;
                }

                const { moduleName, description, icon, parentId, companyId } = req.body;

                const existingModule = await ModuleRepository.findOne({
                    where: {
                        module_name: moduleName,
                        company: { id: companyId },
                    },
                });

                if (existingModule) {
                    res.status(400).json({
                        status: false,
                        message: 'Module Name already exists',
                        data: [],
                    });
                    return;
                }

                const newModule = ModuleRepository.create({
                    module_name: moduleName,
                    description,
                    icon,
                    parent_id: parentId,
                    company: { id: companyId },
                });

                await ModuleRepository.save(newModule);
                res.status(201).json({
                    status: true,
                    message: 'Module created successfully',
                    data: newModule,
                });
                break;
            }

            case 'GET': {
                if (req.params.id) {
                    const module = await ModuleRepository.findOne({
                        where: { id: Number(req.params.id) },
                    });

                    if (!module) {
                        res.status(404).json({
                            status: false,
                            message: 'Module not found',
                            data: [],
                        });
                        return;
                    }

                    res.status(200).json({
                        status: true,
                        message: 'Module fetched successfully',
                        data: module,
                    });
                } else {
                    const modules = await ModuleRepository.find();
                    res.status(200).json({
                        status: true,
                        message: 'Modules fetched successfully',
                        data: modules,
                    });
                }
                break;
            }

            case 'PUT': {
                const module = await ModuleRepository.findOne({
                    where: { id: Number(req.params.id) },
                });

                if (!module) {
                    res.status(404).json({
                        status: false,
                        message: 'Module not found',
                        data: [],
                    });
                    return;
                }

                ModuleRepository.merge(module, req.body);
                await ModuleRepository.save(module);

                res.status(200).json({
                    status: true,
                    message: 'Module updated successfully',
                    data: module,
                });
                break;
            }

            case 'DELETE': {
                const module = await ModuleRepository.findOne({
                    where: { id: Number(req.params.id) },
                });

                if (!module) {
                    res.status(404).json({
                        status: false,
                        message: 'Module not found',
                        data: [],
                    });
                    return;
                }

                await ModuleRepository.remove(module);
                res.status(200).json({
                    status: true,
                    message: 'Module deleted successfully',
                    data: [],
                });
                break;
            }

            default:
                res.status(405).json({
                    status: false,
                    message: 'Method not allowed',
                    data: [],
                });
                break;
        }
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
};