// user.routes.ts
import { Router } from "express";
import { formFields,formsubmission } from "../controllers/controller"; // Ensure correct import

const router = Router();


router.route('/form-fields/:id/:type').get(formFields)
router.route('/form-fields-submission').post(formFields)
router.route('/form-submission/:id/:type').get(formsubmission)


export default router;
