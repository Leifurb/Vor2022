const express = require('express');
const cors = require('cors');

const app = express();
const port = 3000;

const prefix = "/api";
const version = "/vEx1";

app.use(express.json());
app.use(cors());

app.use(function (req, res, next) {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
    next();
});

let invoices = [{ id: 2, invoice_number: "#2021-05-0123", invoiced_by: "Grischa Liebel", invoiced_to: "City of Reykjavik", amount: 15000, paid_status: 'paid' }, 
{ id: 4, invoice_number: "#2021-06-0001", invoiced_by: "Jane Doe", invoiced_to: "Reykjavik University", amount: 500000, paid_status: 'unpaid' },
{ id: 5, invoice_number: "#2021-06-0002", invoiced_by: "Jón Jónsson", invoiced_to: "Icelandair", amount: 500, paid_status: 'unpaid' }];

let currentInvoiceID = 6;

module.exports.resetServerState = function () {
    //Does nothing
};

app.get(prefix + version + '/invoices', (req, res) => {
    return res.status(200).json(invoices);
});

//Test this
app.get(prefix + version + '/invoices/:invoiceId', (req, res) => {
    for (let i = 0; i < invoices.length; i++) {
        if (invoices[i].id == req.params.invoiceId) {0
            res.status(200).json(invoices[i]);
            return;
        }
    }
    res.status(404).json({ 'message': "Invoice with id " + req.params.invoiceId + " does not exist." });
});

app.patch(prefix + version + '/invoices/:invoiceId', (req, res) => {
    if (req.body == undefined){
        return res.status(400).json({'message': 'need body'});
    }
    if (req.body.paid_status != undefined){
        for (let i=0; i<invoices.length; i++){
            if (invoices[i].id == req.params.invoiceId){
                if (invoices[i].paid_status == 'paid'){
                    return res.status(400).json({'message': 'already paid'});
                }
                invoices[i].paid_status = req.body.paid_status;
                return res.status(200).json(invoices[i]);
            }
        }
        return res.status(400).json({'message': 'id not found'});
    }
    return res.status(400).json({'message': 'need body'});

});

app.post(prefix + version + '/invoices', (req, res) => {
    if (req.body === undefined || req.body.invoice_number === undefined || req.body.invoiced_by === undefined || req.body.invoiced_to === undefined || req.body.amount === undefined) {
        return res.status(400).json({ 'message': "invoice_number, invoiced_by, invoiced_to, and amount fields are required in the request body." });
    } else {
        if (isNaN(req.body.amount) || Number(req.body.amount) <= 0 ) {
            return res.status(400).json({ 'message': "Amount needs to be a non-negative number." });
        }
        if (req.body.invoice_number === "") {
            return res.status(400).json({ 'message': "invoice_number is not allowed to be an empty string." });
        }

        let newInvoice = { invoice_number: req.body.invoice_number, invoiced_by: req.body.invoiced_by, invoiced_to: req.body.invoiced_to, id: currentInvoiceID, amount: Number(req.body.amount), paid_status: req.body.paid_status };
        invoices.push(newInvoice);
        currentInvoiceID++;
        return res.status(201).json(newInvoice);
    }
});

app.use('*', (req, res) => {
    res.status(405).send('Operation not supported.');
});

app.listen(port, () => {
    console.log('Invoicing app listening on port ' + port);
});