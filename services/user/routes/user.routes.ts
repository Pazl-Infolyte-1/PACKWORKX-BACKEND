// user.routes.ts
import { Router } from "express";
import { user, login } from "../controllers/user.controller"; // Ensure correct import

const router = Router();

router.route('/user/register').post(user);
router.route('/user/login').post(login);
router.route('/user').get(user);
router.route('/user/:id').put(user).get(user).delete(user);

export default router;
