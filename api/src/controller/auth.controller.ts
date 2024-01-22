/* eslint-disable @typescript-eslint/no-unused-vars */
import { Request, Response } from "express"
import * as bcrypt from "bcrypt"
import * as jwt from "jsonwebtoken"
import * as nanoid from "nanoid"
import { User } from "../models/user.model"
import { sequelize } from "../config/db"

class AuthController {
	async Register(req: Request, res: Response): Promise<void> { 
		try {
			const { name, email, password, confirmPassword } = req.body
			if (!name || !email || !password || !confirmPassword) {
				res.status(400).json({ 
					error: "Please provide all required fields" 
				})
			}

			const existUser = await User.findOne({
				where: { email } 
			})
			if (existUser) {
				res.status(400).json({ 
					message: `User with ${email} already exist` 
				})
			}
			if (!email.includes("@")) {
				res.status(400).json({
					message: "Email format is invalid!"
				})
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
			const uid = "fin-" + id

			await User.create({
				uid: uid,
				name: name,
				email: email,
				password: hashedPassword,
			})
			res.status(201).json({
				message: "User registered successfully",
				data: {
					name,
					email
				}
			})
			
		} catch (error) {
			console.error(error)
			res.status(500).json({
				message: "Internal server error"
			})
		}
	}

	async Login(req: Request, res: Response): Promise<void> {
		try {
			const { email, password } = req.body

			const user = await User.findOne({ 
				where: { email },
				include: [{ model: User, attributes: ["uid"] }]
			})
			
			if (!user) {
				res.status(401).json({
					message: "User not registered"
				})
			}

			const uid = user.uid

			const isMatch = await bcrypt.compare(password, user.password)
			if (!isMatch) {
				res.status(401).json({
					message: "Invalid password"
				})
			}

			const token = jwt.sign({ uid }, process.env.JWT_SECRET as string, {
				expiresIn: 3600
			})

		} catch (error) {
			console.error(error)
			res.status(500).json({
				message: "Internal server error"
			})
		}
	}

	async Logout(req: Request, res: Response): Promise<void> { }

}

export default new AuthController()