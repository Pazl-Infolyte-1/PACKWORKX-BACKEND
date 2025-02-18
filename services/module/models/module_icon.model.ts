
import { Company } from "../../company/models/company.model";
import { Module } from "./module.model";
import { SubModule } from "../../module/models/sub_module.model";
import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
  JoinColumn,
  OneToMany,
} from "typeorm";

@Entity("module_icons")
export class ModuleIcon {
  @PrimaryGeneratedColumn()
  id: number | undefined;

  @Column({ type: "varchar", length: 191, nullable: false })
  icon_name?: string | undefined;

  @Column({ type: "enum", enum: ["active", "inactive"], default: "active" })
  status!: "active" | "inactive";
  icon: any;
  /** ✅ One-to-Many relation with Module **/
  @OneToMany(() => Module, (module) => module.module_icon)
  modules: Module[] | undefined;
   /** ✅ One-to-Many Relationship with SubModules **/
   @OneToMany(() => SubModule, (subModule) => subModule.module_icon)
   sub_modules: SubModule[] | undefined;

}
