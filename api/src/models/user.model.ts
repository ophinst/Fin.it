import { DataTypes } from "sequelize"
import { sequelize } from "../config/db"

export const User = sequelize.define("user", {
	uid: {
		type: DataTypes.STRING,
	},
	name: {
		type: DataTypes.STRING,
		allowNull: false        
	},
	email: {
		type: DataTypes.STRING,
		allowNull: false
	},
	password: {
		type: DataTypes.STRING,
		allowNull: false
	},
	phoneNumber: {
		type: DataTypes.STRING,
	},
	image: {
		type: DataTypes.STRING,
	},
	balance: {
		type: DataTypes.STRING,
	},
	points: {
		type: DataTypes.STRING,
	},
})

// export class User extends Model {
//     declare id :number;
//     declare name: string;
//     declare email: string;
//     declare password: string;
//     declare phoneNumber: string;
//     declare image: string; // Change the type to Buffer | null
//     declare balance: number;
//     declare points: number;
// };

// User.init(
//     {
//         id: {
//             type: new DataTypes.INTEGER,
//             primaryKey: true,
//             autoIncrement: true,
//         },
//         // uid: {
//         //     type: new DataTypes.STRING,
//         //     allowNull: true
//         // },
//         name: {
//             type: new DataTypes.STRING,
//             allowNull: false
//         },
//         email: {
//             type: new DataTypes.STRING,
//             allowNull: false
//         },
//         password: {
//             type: new DataTypes.STRING,
//             allowNull: false
//         },
//         phoneNumber: {
//             type: new DataTypes.STRING,
//             allowNull: false
//         },
//         // image: {
//         //     type: new DataTypes.STRING,
//         //     allowNull: true,
//         // },
//         balance: {
//             type: new DataTypes.INTEGER,
//             allowNull: true
//         },
//         points: {
//             type: new DataTypes.INTEGER,
//             allowNull: true
//         },
//         createdAt: {
//             type: new DataTypes.DATE,
//             allowNull: true
//         },
//         updatedAt: {
//             type: new DataTypes.DATE,
//             allowNull: true
//         }
//     },
//     {
//         tableName: 'user',
//         sequelize,
//     },
// )
