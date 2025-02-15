import { Knex } from "knex";

export async function up(knex: Knex): Promise<void> {
  await knex.schema.createTable("ballots", (table) => {
    table.increments("id").primary(); // Auto-increment ID
    table.string("uuid").notNullable(); // Foreign key to setup
    table.json("ballot").notNullable(); // Ballot data
    table.string("name").notNullable(); // Name of the voter or identifier
    table.timestamps(true, true); // created_at and updated_at
  });
}

export async function down(knex: Knex): Promise<void> {
  await knex.schema.dropTable("ballots");
}
