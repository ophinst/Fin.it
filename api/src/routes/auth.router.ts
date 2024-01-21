import * as express from "express"
import AuthController from "../controller/auth.controller"

const authRouter = express.Router()

authRouter.post("/register", AuthController.Register)

export default authRouter