import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn } from "typeorm";

@Entity("form_fields")
export class FormField {
    @PrimaryGeneratedColumn({ type: "int", unsigned: true })
    id!: number;

    @Column({ type: "int" })
    company_id!: number;

    @Column({ type: "int", unsigned: true })
    form_id!: number;

    @Column({ type: "int", unsigned: true })
    module_id!: number;

    @Column({ type: "varchar", length: 255 })
    label!: string;

    @Column({ type: "varchar", length: 255 })
    name!: string;

    @Column({ type: "varchar", length: 255, nullable: true })
    description?: string;

    @Column({ type: "int", unsigned: true })
    input_type_id!: number;

    @Column({ type: "int" })
    form_group_id!: number;

    @Column({ type: "enum", enum: ["yes", "no"], default: "no" })
    required!: "yes" | "no";

    @Column({ type: "varchar", length: 255, nullable: true })
    placeholder?: string;

    @Column({ type: "varchar", length: 255, nullable: true })
    default_value?: string;

    @Column({ type: "longtext", nullable: true })
    table_data?: string;

    @Column({ type: "varchar", length: 255, nullable: true })
    key_name?: string;

    @Column({ type: "enum", enum: ["row", "column"], nullable: true })
    column_type?: "row" | "column";

    @Column({ type: "int", nullable: true })
    order?: number;

    @Column({ type: "enum", enum: ["static", "dynamic"], default: "static" })
    input_value_type!: "static" | "dynamic";

    @CreateDateColumn({ type: "timestamp", default: () => "CURRENT_TIMESTAMP" })
    created_at!: Date;

    @UpdateDateColumn({ type: "timestamp", default: () => "CURRENT_TIMESTAMP", onUpdate: "CURRENT_TIMESTAMP" })
    updated_at!: Date;

    @Column({ type: "enum", enum: ["active", "inactive"], default: "active" })
    status!: "active" | "inactive";
}
