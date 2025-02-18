import { Request, Response, NextFunction } from "express";
import { AppDataSource } from '../../../config/data-source'; // Adjust path as necessary
import { Module } from '../models/module.model'; // Adjust path as necessary
import Joi from "joi";
import { ModuleIcon } from "../models/module_icon.model";
import { SubModule } from "../models/sub_module.model";
import { ModuleGroup } from "../models/module_group.model";

export const modulesGroup = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
        const moduleGroupRepository = AppDataSource.getRepository(ModuleGroup);

        switch (req.method) {
            case 'POST': {
                const moduleGroupSchema = Joi.object({
                    group_name: Joi.string().min(2).max(255).required().messages({
                        "string.empty": "Sub Module name is required",
                        "string.min": "Sub Module name must be at least 2 characters",
                        "string.max": "Sub Module name cannot exceed 255 characters",
                    }),
                    companyId: Joi.number().integer().min(1).required().messages({
                        "number.empty": "Company Id is required",
                        "number.min": "Company Id must be at least 1",
                    }),
                });

                const { error } = moduleGroupSchema.validate(req.body, { abortEarly: false });
                if (error) {
                    res.status(400).json({
                        status: false,
                        message: "Validation failed",
                        errors: error.details.map((err) => err.message),
                    });
                    return;
                }

                const { groupName,companyId } = req.body;

                const existingModuleGroup = await moduleGroupRepository.findOne({
                    where: {
                        group_name: groupName,
                        company: { id: companyId },
                    },
                });

                if (existingModuleGroup) {
                    res.status(400).json({
                        status: false,
                        message: 'Module Group Name already exists',
                        data: [],
                    });
                    return;
                }

                const newModuleGroup = moduleGroupRepository.create({
                    group_name: groupName,
                    company: companyId ? ({ id: companyId } as any) : null, // ✅ Fix relation
                });

                await moduleGroupRepository.save(newModuleGroup);
                res.status(201).json({
                    status: true,
                    message: 'Module Group created successfully',
                    data: newModuleGroup,
                });
                break;
            }

            case 'GET': {
                if (req.params.id) {
                    const modulesGroup = await moduleGroupRepository.findOne({
                        where: { id: Number(req.params.id) },
                    });

                    if (!modulesGroup) {
                        res.status(404).json({
                            status: false,
                            message: 'Module Group not found',
                            data: [],
                        });
                        return;
                    }

                    res.status(200).json({
                        status: true,
                        message: 'Sub Module fetched successfully',
                        data: modulesGroup,
                    });
                } else {
                    const subModules = await moduleGroupRepository.find();
                    res.status(200).json({
                        status: true,
                        message: 'Modules Group fetched successfully',
                        data: subModules,
                    });
                }
                break;
            }

            case 'PUT': {
                const moduleGroup = await moduleGroupRepository.findOne({
                    where: { id: Number(req.params.id) },
                });

                if (!moduleGroup) {
                    res.status(404).json({
                        status: false,
                        message: 'Module Group not found',
                        data: [],
                    });
                    return;
                }

                moduleGroupRepository.merge(moduleGroup, req.body);
                await moduleGroupRepository.save(moduleGroup);

                res.status(200).json({
                    status: true,
                    message: 'Module Group updated successfully',
                    data: module,
                });
                break;
            }

            case 'DELETE': {
                const module = await moduleGroupRepository.findOne({
                    where: { id: Number(req.params.id) },
                });

                if (!module) {
                    res.status(404).json({
                        status: false,
                        message: 'Module Group not found',
                        data: [],
                    });
                    return;
                }

                await moduleGroupRepository.remove(module);
                res.status(200).json({
                    status: true,
                    message: 'Module Group deleted successfully',
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
                    module_group_id: Joi.number().integer().allow(null).optional(),
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

                const { moduleName, description, icon, module_group_id, companyId } = req.body;

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
                    module_name: moduleName, // ✅ Ensure it exists in Module entity
                    description,
                    module_icon: icon ? ({ id: icon } as any) : null, // ✅ TypeORM expects full entity
                    module_group: module_group_id ? ({ id: module_group_id } as any) : null, // ✅ Fix relation
                    key: moduleName.toLowerCase().replace(/\s/g, '_'),
                    company: companyId ? ({ id: companyId } as any) : null, // ✅ Fix relation
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
                        relations: ["module_icon", "module_group", "company"], // ✅ Fetch relations
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
                    const modules = await ModuleRepository.find({
                        relations: ["module_group", "sub_modules"], // ✅ Fetch related entities
                    });
            
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



export const submodules = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
        const SubModuleRepository = AppDataSource.getRepository(SubModule);

        switch (req.method) {
            case 'POST': {
                const subModuleSchema = Joi.object({
                    subModuleName: Joi.string().min(2).max(255).required().messages({
                        "string.empty": "Sub Module name is required",
                        "string.min": "Sub Module name must be at least 2 characters",
                        "string.max": "Sub Module name cannot exceed 255 characters",
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
                    module_id: Joi.number().integer().allow(null).optional(),
                    is_custom: Joi.allow(null).optional(),
                    companyId: Joi.number().integer().min(1).required().messages({
                        "number.empty": "Company Id is required",
                        "number.min": "Company Id must be at least 1",
                    }),
                });

                const { error } = subModuleSchema.validate(req.body, { abortEarly: false });
                if (error) {
                    res.status(400).json({
                        status: false,
                        message: "Validation failed",
                        errors: error.details.map((err) => err.message),
                    });
                    return;
                }

                const { subModuleName, description, icon, module_id, is_custom, companyId } = req.body;

                const existingSubModule = await SubModuleRepository.findOne({
                    where: {
                        sub_module_name: subModuleName,
                        company: { id: companyId },
                        module: { id: module_id },
                    },
                });

                if (existingSubModule) {
                    res.status(400).json({
                        status: false,
                        message: 'Sub Module Name already exists',
                        data: [],
                    });
                    return;
                }

                const newSubModule = SubModuleRepository.create({
                    sub_module_name: subModuleName, // ✅ Ensure it exists in Module entity
                    description,
                    module: module_id ? ({ id: module_id } as any) : null, // ✅ Fix relation
                    key: subModuleName.toLowerCase().replace(/\s/g, '_'),
                    company: companyId ? ({ id: companyId } as any) : null, // ✅ Fix relation
                });

                await SubModuleRepository.save(newSubModule);
                res.status(201).json({
                    status: true,
                    message: 'Sub Module created successfully',
                    data: newSubModule,
                });
                break;
            }

            case 'GET': {
                if (req.params.id) {
                    const subModules = await SubModuleRepository.findOne({
                        where: { id: Number(req.params.id) },
                    });

                    if (!subModules) {
                        res.status(404).json({
                            status: false,
                            message: 'Sub Module not found',
                            data: [],
                        });
                        return;
                    }

                    res.status(200).json({
                        status: true,
                        message: 'Sub Module fetched successfully',
                        data: subModules,
                    });
                } else {
                    const subModules = await SubModuleRepository.find({
                        relations: ["module", "module.sub_modules","module.module_icon", "module.module_group"],  // ✅ Fetch related entities

                    });
                    res.status(200).json({
                        status: true,
                        message: 'sub Modules fetched successfully',
                        data: subModules,
                    });
                }
                break;
            }

            case 'PUT': {
                const module = await SubModuleRepository.findOne({
                    where: { id: Number(req.params.id) },
                });

                if (!module) {
                    res.status(404).json({
                        status: false,
                        message: 'Sub Module not found',
                        data: [],
                    });
                    return;
                }

                SubModuleRepository.merge(module, req.body);
                await SubModuleRepository.save(module);

                res.status(200).json({
                    status: true,
                    message: 'Sub Module updated successfully',
                    data: module,
                });
                break;
            }

            case 'DELETE': {
                const module = await SubModuleRepository.findOne({
                    where: { id: Number(req.params.id) },
                });

                if (!module) {
                    res.status(404).json({
                        status: false,
                        message: 'Sub Module not found',
                        data: [],
                    });
                    return;
                }

                await SubModuleRepository.remove(module);
                res.status(200).json({
                    status: true,
                    message: 'Sub Module deleted successfully',
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