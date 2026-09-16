import { Injectable, Logger, OnModuleInit } from '@nestjs/common';
import { migrate } from 'drizzle-orm/node-postgres/migrator';
import { DatabaseService } from './database.service.js';

@Injectable()
export class MigrationService implements OnModuleInit {
  private readonly logger = new Logger(MigrationService.name);

  constructor(private readonly database: DatabaseService) {}

  async onModuleInit() {
    await migrate(this.database.db, { migrationsFolder: 'drizzle' });
    this.logger.log('Migraciones al día');
  }
}
