"use strict";

/**
 * Bank CLI application module.
 * Handles user input and executes corresponding commands.
 * Provides an interactive terminal interface for banking operations.
 */

const readline = require("readline");
const { handleCases } = require("./src/handleCases");

console.log(`
    ==================================
           Welcome to Eshop CLI!
    ==================================
    Write 'menu' to see available commands.
    Write 'exit' to close CLI.
`);

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

rl.setPrompt("Eshop: ");
rl.prompt();
/**
 * Main loop that runs indefinitely until 'exit' command is entered.
 */
function startTerminal() {
    rl.on("line", async (input) => {
        const command = input.trim().toLowerCase();

        const result = await handleCases(command);

        if (result === "exit") {
            rl.close();
        } else {
            rl.prompt();
        }
    });
    rl.on("close", () => {
        console.log("Exiting the program...");
        process.exit(0);
    });
}

startTerminal();
