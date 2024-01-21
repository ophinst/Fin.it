/* eslint-disable @typescript-eslint/no-unused-vars */
import { Request, Response } from "express"
import * as bcrypt from "bcrypt"
import * as jwt from "jsonwebtoken"
import * as nanoid from "nanoid"
import {User} from "../models/user.model"


class AuthController {
	async Register(req: Request, res: Response): Promise<void> { 
		try {
			const { name, email, password, confirmPassword } = req.body
			if (!name || !email || !password || !confirmPassword) {
				res.status(400).json({ 
					error: "Please provide all required fields" 
				})
				return
			}

			const existUser = await User.findOne({
				where: { email: email } 
			})
			if (existUser) {
				res.status(400).json({ 
					message: `User with ${email} already exist` 
				})
				return
			}
			if (!email.includes("@")) {
				res.status(400).json({
					message: "Email format is invalid!"
				})
				return
			}
			if (password.length < 8) {
				res.status(400).json({
					message: "Password must be at least 8 characters!"
				})
			}
			if (password !== confirmPassword) {
				res.status(403).json({
					message: "Password and confirm password don't match!"
				})
			}

			const salt = await bcrypt.genSalt()
			const hashedPassword = await bcrypt.hash(password, salt)

			const id = nanoid.nanoid(10)
			const uid = "fin" + id

			const newUser = await User.create({
				uid: uid,
				name: name,
				email: email,
				password: hashedPassword,
			})
			res.status(201).json({
				message: "User registered successfully",
			})
			
		} catch (error) {
			console.error(error)
		}
	}

	async Login(req: Request, res: Response): Promise<void> {
    
	}

	async Logout(req: Request, res: Response): Promise<void> { }

}

export default new AuthController()