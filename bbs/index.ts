import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import Knex from "knex";
import knexConfig from "./knexfile";

dotenv.config();
const env = process.env.NODE_ENV || "development";
const knex = Knex(knexConfig[env]);

const app = express();
app.use(express.json());
app.use(cors());

app.get("/", (_req, res) => {
  res.send("<h1>Hello :)</h1>");
});

app.put("/:uuid", async (req, res) => {
  const { uuid } = req.params;
  const { election, trustees, credentials } = req.body;

  console.log(election, trustees, credentials)

  try {
    await knex("elections").insert({
      uuid,
      election,
      trustees,
      credentials
    });

    res.status(201).json({ success: true, uuid, election, trustees, credentials });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, message: "Error storing election." });
  }
});

app.post("/:uuid/ballots", async (req, res) => {
  const { uuid } = req.params;
  const { ballot, name, demo_plaintexts } = req.body;

  try {
    // Check if election exists
    const election = await knex("elections").select().where({ uuid }).first();
    if (!election) {
      return res.status(404).json({ success: false, message: "Election not found." });
    }

    await knex("ballots").insert({
      election_uuid: uuid,
      ballot,
      name,
      demo_plaintexts: JSON.stringify(demo_plaintexts),
    });

    res.status(201).json({ success: true, election_uuid: uuid, ballot });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, message: "Error storing ballot." });
  }
});

app.get("/:uuid", async (req, res) => {
  const { uuid } = req.params;
  try {
    const setup = await knex("elections").select().where({ uuid }).first();
    const { election, trustees, credentials } = setup;
    if (!election) {
      return res.status(404).json({ success: false, message: "Election not found." });
    }
    res.status(200).json({ success: true, election, trustees, credentials });
  } catch (error) {
    res.status(500).json({ success: false, message: "Error fetching election." });
  }
});

app.get("/:uuid/ballots", async (req, res) => {
  const { uuid } = req.params;
  try {
    const ballots = await knex("ballots").select().where({ election_uuid: uuid });
    res.status(200).json({ success: true, ballots });
  } catch (error) {
    res.status(500).json({ success: false, message: "Error fetching ballots." });
  }
});

// Start Server
const port = process.env.PORT || 8080;
app.listen(port, () => console.log(`App listening on port ${port}!`));
