// user.routes.ts
import { Router } from "express";
import { modules,submodules,modulesgroup } from "../controllers/module.controller";
const router = Router();

router.route('/module').post(modules).get(modules);
router.route('/module/:id').put(modules).get(modules).delete(modules);

router.route('/sub-module').post(submodules).get(submodules);
router.route('/sub-module/:id').put(submodules).get(submodules).delete(submodules);

router.route('/module-group').post(modulesgroup).get(modulesgroup);
router.route('/module-group/:id').put(modulesgroup).get(modulesgroup).delete(modulesgroup);

export default router;
