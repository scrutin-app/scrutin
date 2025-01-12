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
  const { setup } = req.body;

  try {
    const election = await knex("setup").select().where({ uuid }).first();
    if (election) {
      return res.status(401).json({ success: false, message: "Election already exists." });
    }

    await knex("setup").insert({ uuid, setup });
    res.status(201).json({ success: true, uuid, setup });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, message: "Error storing election setup." });
  }
});

app.post("/:uuid/ballots", async (req, res) => {
  const { uuid } = req.params;
  const { ballot, name } = req.body;

  try {
    const election = await knex("setup").select().where({ uuid }).first();
    if (!election) {
      return res.status(404).json({ success: false, message: "Election not found." });
    }

    await knex("ballots").insert({ uuid, ballot, name });

    res.status(201).json({ success: true, uuid, ballot, name });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, message: "Error storing ballot." });
  }
});


app.put("/:uuid/result", async (req, res) => {
  const { uuid } = req.params;
  const { encryptedTally, partialDecryptions, result } = req.body;

  try {
    const election = await knex("setup").select().where({ uuid }).first();
    if (!election) {
      return res.status(404).json({ success: false, message: "Election not found." });
    }

    await knex("encryptedTally").insert({ uuid, encryptedTally });
    for (let i = 0; i < partialDecryptions.length; i++) {
      await knex("partialDecryptions").insert({ uuid, partialDecryption: partialDecryptions[i] });
    }
    await knex("result").insert({ uuid, result });
    res.status(201).json({ success: true, uuid, result });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, message: "Error storing result." });
  }
});


app.get("/:uuid", async (req, res) => {
  const { uuid } = req.params;
  try {
    let response;
    let setup = null, ballots = [], encryptedTally = null, partialDecryptions = [], result = null;

    response = await knex("setup").select().where({ uuid }).first();
    if (response) {
      setup = (typeof response.setup === "string") ? JSON.parse(response.setup) : response.setup;
    }
    if (!setup) {
      return response.status(404).json({ success: false, message: "Election not found." });
    }

    response = await knex("ballots").select().where({ uuid });
    ballots = response.map((o: any) => {
      if (typeof o.ballot === "string") {
        return JSON.parse(o.ballot);
      } else {
        return o.ballot;
      }
    });

    response = await knex("encryptedTally").select().where({ uuid }).first();
    if (response) {
      encryptedTally = (typeof response.encryptedTally === "string") ? JSON.parse(response.encryptedTally) : response.encryptedTally;
    }

    response = await knex("partialDecryptions").select().where({ uuid });
    partialDecryptions = response.map((o: any) => {
      if (typeof o.partialDecryption === "string") {
        return JSON.parse(o.partialDecryption);
      } else {
        return o.partialDecryption;
      }
    });

    response = await knex("result").select().where({ uuid }).first();
    if (response) {
      result = typeof response.result === "string" ? JSON.parse(response.result) : response.result;
    }

    res.status(200).json({ success: true, setup, ballots, partialDecryptions, encryptedTally, result });
  } catch (error) {
    console.log(error);
    res.status(500).json({ success: false, message: "Error fetching election." });
  }
});

//app.get("/:uuid/ballots", async (req, res) => {
//  const { uuid } = req.params;
//  try {
//    const ballots = await knex("ballots").select().where({ election_uuid: uuid });
//    res.status(200).json({ success: true, ballots });
//  } catch (error) {
//    res.status(500).json({ success: false, message: "Error fetching ballots." });
//  }
//});

// Start Server
const port = process.env.PORT || 8080;
app.listen(port, () => console.log(`App listening on port ${port}!`));
