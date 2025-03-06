/**
 * Route for eshop.
 */
"use strict";

const express = require("express");
const router = express.Router();
const bodyParser = require("body-parser");
const urlencodedParser = bodyParser.urlencoded({ extended: false });
const eshop = require("../src/eshop.js");
const sitename = "| BuckStar Online Shopping";

module.exports = router;

router.get("/index", (req, res) => {
    let data = {
        title: `Welcome ${sitename}`
    };

    res.render("eshop/index", data);
});

router.get("/about", (req, res) => {
    let data = {
        title: `About ${sitename}`
    };

    res.render("eshop/about", data);
});

// All products route
router.get("/products", async (req, res) => {
    let data = {
        title: `Product Overview ${sitename}`
    };

    data.products = await eshop.showProductsOverview();
    res.render("eshop/products", data);
});

// All kategories
router.get("/kategori", async (req, res) => {
    let data = {
        title: `Kategori Overview ${sitename}`
    };

    data.categories = await eshop.ViewCategoriesWithProducts();
    res.render("eshop/kategori", data);
});

// create a new product
router.get("/create", (req, res) => {
    let data = {
        title: `Create new product ${sitename}`
    };

    res.render("eshop/create", data);
});

router.post("/create", urlencodedParser, async (req, res) => {
    await eshop.addProduct(req.body.produkt_namn,
        req.body.produkt_beskrivning,
        req.body.produkt_pris);
    res.redirect("/eshop/products");
});

// view product based on id
router.get("/product/:id", async (req, res) => {
    let id = req.params.id;
    let data = {
        title: `Account ${id} ${sitename}`,
        productId: id
    };

    data.res = await eshop.showProduct(id);

    res.render("eshop/product-view", data);
});

// Edit product based on id
router.get("/edit/:id", async (req, res) => {
    let id = req.params.id;
    let data = {
        title: `Edit Product ${id} ${sitename}`,
        productId: id
    };

    data.res = await eshop.showProduct(id);
    res.render("eshop/product-edit", data);
});

router.post("/edit", urlencodedParser, async (req, res) => {
    console.log(req.body);

    await eshop.editProduct(req.body.produkt_id,
        req.body.produkt_namn,
        req.body.produkt_beskrivning,
        req.body.produkt_pris);
    res.redirect(`/eshop/product/${req.body.produkt_id}`);
});



router.get("/delete/:id", async (req, res) => {
    let id = req.params.id;
    let data = {
        title: `Delete Product ${id} ${sitename}`,
        productId: id
    };

    data.res = await eshop.showProduct(id);
    res.render("eshop/product-delete", data);
});

router.post("/delete", urlencodedParser, async (req, res) => {
    console.log(JSON.stringify(req.body, null, 4));
    await eshop.deleteProduct(req.body.produkt_id);
    res.redirect(`/eshop/products`);
});
