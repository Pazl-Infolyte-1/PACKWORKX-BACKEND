import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, OneToMany } from "typeorm";
import { FormSubmissionValue } from "./formSubmissionValue.model";

@Entity("form_submissions")
export class FormSubmission {
    @PrimaryGeneratedColumn()
    id: number | undefined;

    @Column()
    company_id: number | undefined;

    @Column()
    form_id: number | undefined;

    @CreateDateColumn()
    created_at: Date | undefined;

    @UpdateDateColumn()
    updated_at: Date | undefined;

    @Column({ type: "enum", enum: ["active", "inactive"], default: "active" })
    status: "active" | "inactive" | undefined;

    @OneToMany(() => FormSubmissionValue, value => value.submission, { cascade: true })
    values: FormSubmissionValue[] | undefined;
}
