import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn,OneToMany } from 'typeorm';
import { Company } from '../../company/models/company.model'; // Adjust path as necessary
import { ModuleGroup } from '../models/module_group.model'; // Adjust path as necessary
import { ModuleIcon } from '../models/module_icon.model'; // Adjust path as necessary
import { SubModule } from './sub_module.model'; // Ensure this path is correct
@Entity({ name: 'modules' })
export class Module {
  @PrimaryGeneratedColumn()
  id!: number;

  @Column({ type: 'varchar', length: 255, nullable: false })
  module_name!: string;

  @Column({ type: 'varchar', length: 255, nullable: false })
  description!: string;

  @ManyToOne(() => ModuleIcon, { nullable: true })
  @JoinColumn({ name: 'module_icon_id' })
  module_icon?: ModuleIcon;

  @OneToMany(() => Module, (module) => module.module_group)
  modules: Module[] | undefined;

  @Column({ type: 'varchar', length: 255, nullable: false })
  key!: string;

  @ManyToOne(() => Company, { nullable: true })
  @JoinColumn({ name: 'company_id' })
  company?: Company;
  
  @OneToMany(() => SubModule, (subModule) => subModule.module)
  sub_modules?: SubModule[];

  @Column({ type: "enum", enum: ["active", "inactive"], default: "active" })
  status!: "active" | "inactive";
  module_group: any;
}