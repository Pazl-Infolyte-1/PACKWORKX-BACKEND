// user.routes.ts
import { Router } from "express";
import { modules } from "../controllers/module.controller";
const router = Router();

router.route('/module').post(modules).get(modules);
router.route('/module/:id').put(modules).get(modules).delete(modules);

export default router;
