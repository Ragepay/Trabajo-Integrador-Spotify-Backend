import { genSaltSync, hashSync, compareSync } from "bcrypt";

const createHashUtil = (password) => hashSync(password, genSaltSync(10));
const verifyHashUtil = (password, dbPassword) => compareSync(password, dbPassword);

export { createHashUtil, verifyHashUtil };
