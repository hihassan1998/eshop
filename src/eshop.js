/**
 * A module exporting functions to access the bank database.
 */
"use strict";

module.exports = {
    showProduct: showProduct,
    showProductsOverview: showProductsOverview,
    ViewCategoriesWithProducts: ViewCategoriesWithProducts,
    addProduct: addProduct,
    editProduct: editProduct,
    deleteProduct: deleteProduct,
    // the funcs for cli
    showAbout: showAbout,
    showLager: showLager,
    GetLagerPlatsOverview: GetLagerPlatsOverview,
    invAdd: invAdd,
    invDel: invDel,
    showLogs: showLogs
};

const mysql = require("promise-mysql");
const config = require("../config/db/eshop.json");
// const { AsTable } = require('./tableFormat.js');
let db;



/**
 * Main function.
 * @async
 * @returns void
 */
(async function () {
    db = await mysql.createConnection(config);

    process.on("exit", () => {
        db.end();
    });
})();



/**
 * Show the names of the people who worked on this project.
 *
 * @returns {string} The message containing the names of the project contributors.
 */
async function showAbout() {
    return console.log(`
        ===================================
                BuckStar Eshop CLI!
        ===================================
        This Eshop Cli is creaded by:
        Hassan Hussain  |   Ackronym: hahi24
        ====================================
    `);
}




/**
 * Show all entries in the account table.
 *
 * @async
 * @returns {RowDataPacket} Resultset from the query.
 */
async function showLager() {
    let sql = `CALL showLager();`;
    let res;

    res = await db.query(sql);
    const lagerData = res[0];

    // console.log(res);
    console.info(`SQL: ${sql} got ${res.length} rows.`);
    // console.log(AsTable(lagerData));
    console.table(lagerData);

    return res[0];
}

async function GetLagerPlatsOverview(searchStr = '') {
    const db = await mysql.createConnection(config);
    const sql = 'CALL GetLagerPlatsOverview();';
    const [rows] = await db.query(sql);

    // Filter results based on searchStr
    const filteredRows = rows.filter(row => {
        return (row.produkt_id.toString().includes(searchStr) ||
            (row.produkt_namn &&
                row.produkt_namn.toLowerCase().includes(searchStr.toLowerCase())) ||
            (row.lagerhylla && row.lagerhylla.toLowerCase().includes(searchStr.toLowerCase())));
    });

    // console.log(AsTable(filteredRows));
    console.table(filteredRows);
    console.info(`SQL: ${sql} got ${rows.length} rows.`);
    return filteredRows;
}
/**
 * Add a given number of products from given shelf based on cli command.
 *
 * @async
 * @returns {RowDataPacket} Resultset from the query.
 */
async function invAdd(productid, shelf, number) {
    const sql = 'CALL invadd(?, ?, ?)';

    try {
        await db.query(sql, [productid, shelf, number]);
        console.log(`${number} units of product ${productid} added to shelf ${shelf}.`);
    } catch (error) {
        console.log('Error:', error.message);
    }
}
/**
 * Delete a given number of products from given shelf based on cli command.
 *
 * @async
 * @returns {RowDataPacket} Resultset from the query.
 */
async function invDel(productid, shelf, number) {
    const sql = 'CALL invdel(?, ?, ?)';

    try {
        await db.query(sql, [productid, shelf, number]);
        // If successful
        console.log(`${number} units of product ${productid} removed from shelf ${shelf}.`);
    } catch (error) {
        // Log the error message
        console.log('Error:', error.message);
    }
}

// showLogs
/**
 * Show logs at a specific index from table.
 *
 * @async
 * @returns {RowDataPacket} Resultset from the query.
 */
async function showLogs(logEntries) {
    let sql = `CALL showLog(?);`;
    let res;

    res = await db.query(sql, [logEntries]);
    const productData = res[0];

    // console.log(res);
    console.info(`SQL: ${sql} got ${res.length} rows.`);
    // console.log(AsTable(productData));
    console.table(productData);
    return res[0];
}


/**
 * Show all entries in the account table.
 *
 * @async
 * @returns {RowDataPacket} Resultset from the query.
 */
async function showProductsOverview() {
    let sql = `CALL GetProductsOverview();`;
    let res;

    res = await db.query(sql);
    const productData = res[0];

    // console.log(res);
    console.info(`SQL: ${sql} got ${res.length} rows.`);
    // console.log(AsTable(productData));
    console.table(productData);


    return res[0];
}
/**
 * Show all entries in the account table.
 *
 * @async
 * @returns {RowDataPacket} Resultset from the query.
 */
async function ViewCategoriesWithProducts() {
    let sql = `CALL ViewCategoriesWithProducts();`;
    let res;

    res = await db.query(sql);
    //console.log(res);
    console.info(`SQL: ${sql} got ${res.length} rows.`);

    return res[0];
}


/**
 * Add a new product.
 *
 * @async
 * @param {string} name        The name of the product.
 * @param {string} description The description of the product.
 * @param {number} price       The price of the product.
 *
 * @returns {void}
 */
async function addProduct(name, description, price) {
    let sql = `CALL AddProdukt(?, ?, ?);`;
    let res;

    res = await db.query(sql, [name, description, price]);
    console.log(res);
    console.info(`SQL: ${sql} got ${res.length} rows.`);
}

/**
 * Show details for a product.
 *
 * @async
 * @param {string} id A id of the account.
 *
 * @returns {RowDataPacket} Resultset from the query.
 */
async function showProduct(id) {
    let sql = `CALL showProduct(?);`;
    let res;

    res = await db.query(sql, [id]);
    //console.log(res);
    console.info(`SQL: ${sql} got ${res.length} rows.`);

    return res[0];
}



/**
 * Edit an existing product.
 *
 * @async
 * @param {number} id          The ID of the product to edit.
 * @param {string} name        The new name of the product.
 * @param {string} description The new description of the product.
 * @param {number} price       The new price of the product.
 *
 * @returns {void}
 */
async function editProduct(id, name, description, price) {
    let sql = `CALL EditProdukt(?, ?, ?, ?);`;
    let res;

    res = await db.query(sql, [id, name, description, price]);
    console.log(res);
    console.info(`SQL: ${sql} got ${res.length} rows.`);
}


/**
 * Delete an account.
 *
 * @async
 * @param {string} id The id of the account.
 *
 * @returns {void}
 */
async function deleteProduct(id) {
    let sql = `CALL DeleteProdukt(?);`;
    let res;

    res = await db.query(sql, [id]);
    //console.log(res);
    console.info(`SQL: ${sql} got ${res.length} rows.`);
}
