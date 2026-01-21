import {Sequelize} from 'sequelize';

const connect = new Sequelize({
    host: "localhost",
    database: "chatdb",
    dialect: "mysql",
    username: "root",
    password: "123456789"
}
)

export const connectDB = async () => {
    try{
        await connect.authenticate();
        await connect.sync({ alter: true});
        console.log("✅ Kết nối database thành công");
    }catch(err){
        console.log("Kết nối database thất bại: ",  err);
    }
}
