import express, { Application, Request, Response } from "express";
import {prisma} from "./config/prisma";
import { v4 as uuid } from 'uuid';
export class App {
  private app: Application;

  constructor() {
    this.app = express();
    this.middlewares();
    this.routes();
  }

  private middlewares(): void {
    this.app.use(express.json());
  }

  private routes(): void {
    // Health check
    this.app.get("/", (req: Request, res: Response) => {
      res.send("API is running");
    });

    // TEST CREATE USER
    this.app.post("/users", async (req: Request, res: Response) => {
      try {
        const { username, email, password } = req.body;

        const user = await prisma.users.create({
          data: {
            user_id: uuid(),
            username,
            email,
            password,
          },
        });

        res.json(user);
      } catch (error: any) {
        res.status(500).json({
          message: "Create user failed",
          error: error.message,
        });
      }
    });

    // TEST GET USERS
    this.app.get("/users", async (req: Request, res: Response) => {
      const users = await prisma.users.findMany();
      res.json(users);
    });
  }

  public async start(): Promise<void> {
    const PORT = 3000;
    this.app.listen(PORT, () => {
      console.log("🚀 Server listening on port: " + PORT);
    });
  }
}
