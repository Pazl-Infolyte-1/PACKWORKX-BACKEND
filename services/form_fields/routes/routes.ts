// user.routes.ts
import { Router } from "express";
import { formFields,formFieldsSubmissionValue,formsubmission } from "../controllers/controller"; // Ensure correct import

const router = Router();


router.route('/form-fields/:id').get(formFields)
router.route('/form-submission/:id').get(formsubmission)
router.route('/form-fields-submission').post(formFields)
router.route('/form-fields-submission/:id').get(formFieldsSubmissionValue)
router.route('/form-fields-submission/:id').put(formFieldsSubmissionValue)

export default router;
