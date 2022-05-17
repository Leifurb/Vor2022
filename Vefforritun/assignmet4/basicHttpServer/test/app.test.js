let chai = require('chai');
let chaiHttp = require('chai-http');
chai.use(chaiHttp);

require('../expressHttpServer');

describe("Endpoints", function() {
    it("GET /", function (done) {
        chai.request('http://localhost:3000').get('/').end( (err, res) => {
            chai.expect(res).to.have.status(200);
            chai.expect(res).to.have.header('Content-type', /^text/);
            chai.expect(res.text).to.eql('Hello World!');
            done();
        });
    });

    it("POST /users", function (done) {
        chai.request('http://localhost:3000')
            .post('/users')
            .set('Content-type', 'application/json')
            .send({'username':'Grischa', 'age':'10'})
            .end( (err, res) => {
            chai.expect(res).to.have.status(201);
            chai.expect(res).to.be.json;
            chai.expect(res.body).to.be.a('object');
            chai.expect(res.body).to.have.property('username').eql('Grischa');
            chai.expect(res.body).to.have.property('age').eql('10');
            chai.expect(res.body).to.have.property('id');
            chai.expect(Object.keys(res.body).length).to.be.eql(3);
            done();
        });
    });

    it("POST /users failure", function (done) {
        chai.request('http://localhost:3000')
            .post('/users')
            .set('Content-type', 'application/json')
            .send({'age':'10'})
            .end( (err, res) => {
            chai.expect(res).to.have.status(400);
            chai.expect(res).to.be.json;
            chai.expect(res.body).to.be.a('object');
            chai.expect(res.body).to.have.property('message').eql('No username defined.');
            chai.expect(Object.keys(res.body).length).to.be.eql(1);
            done();
        });
    });
});
