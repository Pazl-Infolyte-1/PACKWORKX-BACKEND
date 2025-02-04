import { Entity, PrimaryGeneratedColumn, Column, Unique, CreateDateColumn, UpdateDateColumn, OneToMany,JoinColumn } from 'typeorm';
import { User } from '../../user/models/user.model'; // Adjust the path as necessary

enum CompanyStatus {
    ACTIVE = 'active',
    INACTIVE = 'inactive',
}

enum LoginStatus {
    ENABLE = 'enable',
    DISABLE = 'disable',
}

@Entity({ name: 'companies' })
@Unique(['email', 'phone'])
export class Company {
    @PrimaryGeneratedColumn()
    id!: number;

    @Column({ type: 'varchar', length: 255, nullable: false, comment: 'Company name' })
    name!: string;

    // One-to-many relation with User
    @OneToMany(() => User, (user) => user.company)
    users!: User[];

    @Column({ type: 'varchar', length: 255, nullable: false, comment: 'Company email' })
    email!: string;

    @Column({ type: 'varchar', length: 20, nullable: true, comment: 'Company phone number' })
    phone?: string;

    @Column({ type: 'varchar', length: 255, nullable: true, comment: 'Company website' })
    website?: string;

    @Column({ type: 'varchar', length: 255, nullable: true, comment: 'Company address' })
    address?: string;

    @Column({ type: 'varchar', length: 100, nullable: true, comment: 'City' })
    city?: string;

    @Column({ type: 'varchar', length: 100, nullable: true, comment: 'State' })
    state?: string;

    @Column({ type: 'varchar', length: 100, nullable: true, comment: 'Country' })
    country?: string;

    @Column({ type: 'varchar', length: 20, nullable: true, comment: 'ZIP code' })
    zip?: string;

    @Column({ type: 'varchar', length: 3, nullable: true, comment: 'Country code' })
    countryCode?: string;

    @Column({ type: 'varchar', length: 255, nullable: true, comment: 'Company logo URL' })
    logo?: string;

    @Column({ type: 'varchar', length: 100, nullable: true, comment: 'Timezone' })
    timezone?: string;

    @Column({ type: 'varchar', length: 100, nullable: true, comment: 'Date format' })
    date_format?: string;

    @Column({ type: 'varchar', length: 100, nullable: true, comment: 'Time format' })
    time_format?: string;

    @Column({ type: 'varchar', length: 100, nullable: true, comment: 'Latitude' })
    latitude?: string;

    @Column({ type: 'varchar', length: 100, nullable: true, comment: 'Longitude' })
    longitude?: string;

    @Column({ type: 'int', nullable: true, comment: 'Number of tickets' })
    ticket_count?: number;

    @Column({ type: 'int', nullable: true, comment: 'Number of users' })
    user_count?: number;

    @Column({ type: 'enum', enum: CompanyStatus, default: CompanyStatus.ACTIVE, comment: 'Company status' })
    status!: CompanyStatus;

    @Column({ type: 'timestamp', nullable: true, comment: 'Validity start date' })
    valid_from?: Date;

    @Column({ type: 'timestamp', nullable: true, comment: 'Validity end date' })
    valid_till?: Date;

    @Column({ type: 'enum', enum: LoginStatus, default: LoginStatus.ENABLE, comment: 'Login status' })
    login!: LoginStatus;

    @Column({ type: 'enum', enum: LoginStatus, default: LoginStatus.ENABLE, comment: 'Email notifications status' })
    email_notifications!: LoginStatus;

    @CreateDateColumn({ type: 'timestamp', comment: 'Creation date' })
    createdAt!: Date;

    @UpdateDateColumn({ type: 'timestamp', comment: 'Last update date' })
    updatedAt!: Date;
}
