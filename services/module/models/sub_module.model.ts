
import { Company } from "../../company/models/company.model"; // Ensure this file exists
import { Module } from "../../module/models/module.model";
import { ModuleIcon } from "../../module/models/module_icon.model";
import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
  JoinColumn,
} from "typeorm";

@Entity("sub_modules")
export class SubModule {
  @PrimaryGeneratedColumn()
  id: number | undefined;

  @Column({ type: "varchar", length: 191, nullable: false })
  sub_module_name?: string | undefined;

  @Column({ type: "varchar", length: 191, nullable: true })
  description?: string;

  @Column({ type: "varchar", length: 191, nullable: true })
  key?: string;

  @ManyToOne(() => Company, (company) => company.modules, { onDelete: "RESTRICT", onUpdate: "RESTRICT", nullable: true })
  @JoinColumn({ name: "company_id" })
  company?: Company;

  /** ✅ Many-to-One Relationship with Module **/
  @ManyToOne(() => Module, (module) => module.sub_modules, { onDelete: "CASCADE", onUpdate: "CASCADE", nullable: true })
  @JoinColumn({ name: "module_id" })
  module?: Module;

  /** ✅ Many-to-One Relationship with ModuleIcon **/
  @ManyToOne(() => ModuleIcon, (icon) => icon.sub_modules, { onDelete: "SET NULL", onUpdate: "CASCADE", nullable: true })
  @JoinColumn({ name: "module_icon_id" })
  module_icon?: ModuleIcon;

  @Column({ type: "enum", enum: ["active", "inactive"], default: "active" })
  status!: "active" | "inactive";

  @CreateDateColumn({ type: "timestamp", nullable: true })
  created_at: Date | undefined;

  @UpdateDateColumn({ type: "timestamp", nullable: true })
  updated_at: Date | undefined;
}
