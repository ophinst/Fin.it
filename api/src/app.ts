import * as cors from "cors"
import * as express from "express"
import * as morgan from "morgan"

import authRouter from "./routes/auth.router"
import userRouter from "./routes/user.router"

const app = express() 

const globalApiPrefix = "/api"
app.use(globalApiPrefix, express.json())

app.use(cors({
	credentials: true,
	origin: "*",
}))
app.use(morgan("tiny"))
app.disable("x-powered-by")

app.use(`${globalApiPrefix}/auth`, authRouter)
app.use(`${globalApiPrefix}/user`, userRouter)

const PORT = process.env.PORT || 3000
app.listen(PORT, () => {
	console.log(`Server is running on port localhost:${PORT}`)
})