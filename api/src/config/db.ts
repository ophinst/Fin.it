import { Sequelize } from "sequelize"

export const sequelize = new Sequelize({
	dialect: "postgres",
	host: "localhost",
	port: 5433,
	username: "finit",
	password: "12345678",
	database: "finit",
})

try {
	sequelize.authenticate()
	console.log("Database Connected!")
	sequelize.sync()
} catch (err) {
	console.error(err)
}