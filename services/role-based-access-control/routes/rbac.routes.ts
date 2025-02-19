// user.routes.ts
import { Router } from "express";
import { rbac } from "../controllers/rbac.controller"; // Ensure correct import

const router = Router();


router.route('/rbac').get(rbac)

export default router;
