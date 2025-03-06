"use strict";

/**
 * A module that handles the user's selected commands.
 * Calls the corresponding function based on the user's input.
 */

const { showAbout, showProductsOverview, showLager } = require("./eshop");
const { GetLagerPlatsOverview, invDel, invAdd, showLogs } = require("./eshop");
const { showMenu } = require("./menu");

/**
 * Handle commands based on users input.
 */
async function handleCases(command) {
    // let [cmd, searchStr, prodtid, slf, num] = command.split(" ");
    let parts = command.split(" ");
    let cmd = parts[0];
    let searchStr = parts[1];
    let logEntries = parseInt(parts[1]);
    let productid = parts[1];
    let shelf = parts[2];
    let number = parseInt(parts[3]);


    switch (cmd) {
        case "menu":
            showMenu();
            return;
        case "about":
            await showAbout();
            return;
        case "product":
            await showProductsOverview();
            return;
        case "shelf":
            await showLager();
            return;
        case "log":
            if (logEntries) {
                console.log(logEntries);
                await showLogs(logEntries);
            } else {
                console.log("No logs found!! check database (Trigger)-configuration.");
            }
            return;
        case "inv":
            if (searchStr) {
                await GetLagerPlatsOverview(searchStr);
            } else {
                await GetLagerPlatsOverview();
            }
            return;
        case "invadd":
            if (productid && shelf && number) {
                await invAdd(productid, shelf, number);
            } else {
                console.log(`prodid: ${productid}, shelfnum: ${shelf}, number: ${number}`);
                console.log("Usage: invadd <productid> <shelf> <number>");
            }
            return;
        case "invdel":
            if (productid && shelf && number) {
                await invDel(productid, shelf, number);
            } else {
                console.log("Usage: invdel <productid> <shelf> <number>");
            }
            return;
        case "exit":
            return 'exit';
        default:
            console.log("Unknown command. Type 'menu' to see available commands.");
            return;
    }
}

module.exports = { handleCases };
