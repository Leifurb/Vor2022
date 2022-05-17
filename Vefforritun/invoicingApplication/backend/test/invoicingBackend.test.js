//Importing the application to test
let server = require('../invoicingBackend');

//These are the actual modules we use
let chai = require('chai');
let should = chai.should();
let chaiHttp = require('chai-http');
chai.use(chaiHttp);

let apiUrl = "http://localhost:3000";

describe('Invoice endpoint tests', () => {
    beforeEach((done) => {
        server.resetServerState();
        done();
    });
    
    it("Get /api/vEx1/invoices success", function (done) {
        chai.request(apiUrl)
            .get('/api/vEx1/invoices')
            .end((err, res) => {
                res.should.have.status(200);
                res.should.be.json;
                done();
            });
    });

    it("Get /api/vEx1/invoices/:invoiceId success", function (done) {
        chai.request(apiUrl)
            .get('/api/vEx1/invoices/2')
            .end((err, res) => {
                res.should.have.status(200);
                res.should.be.json;
                chai.expect(res.body).to.have.property('id' &&' invoice_number' && 'invoiced_by' && 'invoiced_to' && 'amount' && 'paid_status');
                chai.expect(res.body.id).to.equal(2);
                chai.expect(res.body.invoice_number).to.equal('#2021-05-0123');
                chai.expect(res.body.invoiced_by).to.equal('Grischa Liebel');
                chai.expect(res.body.invoiced_to).to.equal('City of Reykjavik');
                chai.expect(res.body.amount).to.equal(15000);
                chai.expect(res.body.paid_status).to.equal('paid');
                done();
            });
    });
});
