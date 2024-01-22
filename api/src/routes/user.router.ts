import * as express from "express";
import UserController from "../controller/user.controller";

const userRouter = express.Router();

userRouter.get("/data", UserController.getUser);

export default userRouter;