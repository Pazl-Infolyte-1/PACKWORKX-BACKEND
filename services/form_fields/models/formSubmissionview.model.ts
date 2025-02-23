import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn } from "typeorm";

@Entity("form_submissions_view")
export class FormSubmissionsView {
    @PrimaryGeneratedColumn()
    id!: number;

    @Column({ type: "int" })
    company_id!: number;

    @Column({ type: "int", unsigned: true })
    form_id!: number;

    @Column({ type: "int", unsigned: true })
    form_field_id!: number;

    @Column({ type: "int", default: 1 }) // Default order is 1
    form_submissions_order!: number;

    @Column({ type: "enum", enum: ["active", "inactive"], default: "active" })
    status!: "active" | "inactive";

    @CreateDateColumn({ type: "datetime", nullable: true })
    created_at!: Date;

    @UpdateDateColumn({ type: "datetime", nullable: true })
    updated_at!: Date;

    @Column({ type: "int", default: 1 })
    created_by!: number;

    @Column({ type: "int", default: 1 })
    updated_by!: number;
}
