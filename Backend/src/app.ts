import express, {Application} from 'express';
import { connectDB } from './config/connectDB';


export class App{
    private app: Application;
    constructor(){
        this.app = express();
        this.routes()
    }

    private routes() {
        this.app.get('/', (req, res) => {
            res.send('API is running');
        });
    }
    public async start(): Promise<void>{
        await connectDB()
        const PORT  = 3000;
        this.app.listen(PORT, () => {
            console.log("Server listening on port: " + PORT);
        })
    }


}