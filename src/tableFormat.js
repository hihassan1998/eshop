/**
 * Ett modul som används för att formatera tabeller i huvudterminalfilerna för terminalen.
 */
"use strict";
/**
 * Formaterar och returnerar en resultatset som en tabell med detaljer om lärare.
 * Funktionen skapar dynamiskt en tabell med kolumnnamn och
 * data baserat på resultatet från databasen.
 * Tabellens utseende kan anpassas beroende på antalet kolumner och rader.
 *
 * @param {Array} res Resultat från en databasfråga som innehåller lärares information.
 * @returns {string} Den formaterade tabellen som en sträng, redo att skrivas ut.
 */

module.exports = {
    AsTable: AsTable
};

function AsTable(res) {
    if (!res || res.length === 0) {
        return 'Inga resultat funna.';
    }
    let str = "";

    // Hämta kolumnnamn dynamiskt
    const columns = Object.keys(res[0]);

    // En separatorrad före rubriken
    str += "-".repeat(columns.length * 16) + "\n";

    // Tabellrubrik med dynamiska kolumnnamn
    columns.forEach(col => {
        str += col.padEnd(15) + "|";
    });
    str += "\n";

    // Tabellrubrik med dynamiska kolumnnamn
    str += "-".repeat(columns.length * 16) + "\n";

    // Lägg till data-rader dynamiskt
    res.forEach(row => {
        str += "| ";
        columns.forEach(col => {
            str += (row[col] ? row[col].toString().padEnd(14) : "N/A".padEnd(14)) + "| ";
        });
        str += "\n";
    });

    // En slutlig separatorrad
    str += "-".repeat(columns.length * 16) + "\n";

    return str;
}
