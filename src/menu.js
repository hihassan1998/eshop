/**
 * A module that displays a menu with available commands in the eshop CLI application.
 * The `showMenu` function prints a list of commands and their descriptions.
 */

"use strict";
function showMenu() {
    console.log(`
    Choose a command from the following options:
    ------------------------------------------------
    menu              - Show this menu.
    exit              - Exit the application (Ctrl-C works as well).
    about             - Show the names of those who worked on this task.
    log <number>      - Show the last <number> rows from the log table.
    product           - Show all products and their IDs.
    shelf             - Show all shelves in the warehouse.
    inv               - Show a table of products in stock and their quantities.
    inv <str>         - Filter the inventory list by product ID, product name, or shelf.
    invadd <productid> <shelf> <number> - Add a certain number of products to a shelf.
    invdel <productid> <shelf> <number> - Remove a certain number of products from a shelf.
    `);
}
module.exports = { showMenu };
