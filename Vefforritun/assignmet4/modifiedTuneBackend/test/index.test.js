//Importing the application to test
let server = require('../index');

//These are the actual modules we use
let chai = require('chai');
let should = chai.should();
let chaiHttp = require('chai-http');
chai.use(chaiHttp);

let apiUrl = "http://localhost:3000";

describe('Endpoint tests', () => {
    //###########################
    //The beforeEach function makes sure that before each test, 
    //there are exactly two tunes and two genres.
    //###########################
    beforeEach((done) => {
        server.resetState();
        done();
    });

    //###########################
    //Write your tests below here
    //###########################

    // Do something weird
    it("GET /randomURL causes 405", function (done) {
        chai.request(apiUrl)
            .get('/randomURL')
            .end((err, res) => {
                res.should.have.status(405);
                done();
            });
    });

    it("GET /api/v1/api/v1/tunes has status code 200", function (done) {
        chai.request(apiUrl)
            .get('/api/v1/tunes')
            .end((err, res) => {
                chai.expect(res).to.have.status(200);
                chai.expect(res).to.be.json;
                chai.expect(res.body).to.be.a('array');
                chai.expect(res.body).length(2);
                done();
            });
    });

    it("GET /api/v1/genres/:genreId/tunes/:tuneId has status code 200", function (done) {
        chai.request(apiUrl)
            .get('/api/v1/genres/0/tunes/3')
            .end((err, res) => {
                chai.expect(res).to.have.status(200);
                chai.expect(res).to.be.json;
                chai.expect(res.body).to.be.a('object');
                chai.expect(res.body).to.have.property('id').eql('3');
                chai.expect(res.body).to.have.property('name').eql('Seven Nation Army');
                chai.expect(res.body).to.have.property('genreId').eql('0');
                chai.expect(res.body).to.have.property('content').eql([{note: "E5", duration: "4n", timing: 0}, {note: "E5", duration: "8n", timing: 0.5}, {note: "G5", duration: "4n", timing: 0.75}, {note: "E5", duration: "8n", timing: 1.25}, {note: "E5", duration: "8n", timing: 1.75}, {note: "G5", duration: "4n", timing: 1.75}, {note: "F#5", duration: "4n", timing: 2.25}]);
                done();
            });
    });

    it("PATCH /api/v1/genres/:genreId/tunes/:tuneId has status code 200", function (done) {
        chai.request(apiUrl)
            .patch('/api/v1/genres/0/tunes/3')
            .set('Content-type', 'application/json')
            .send({name: "new name", genreId: '1', content: [{note: "E1", duration: "4n", timing: 1}, {note: "E5", duration: "8n", timing: 0.5}, {note: "G5", duration: "4n", timing: 0.75}, {note: "E5", duration: "8n", timing: 1.25}, {note: "E5", duration: "8n", timing: 1.75}, {note: "G5", duration: "4n", timing: 1.75}, {note: "F#5", duration: "4n", timing: 2.25}] })
            .end((err, res) => {
                chai.expect(res).to.have.status(200);
                chai.expect(res).to.be.json;
                chai.expect(res.body).to.be.a('object');
                chai.expect(res.body).to.have.property('id').eql('3');
                chai.expect(res.body).to.have.property('name').eql('new name');
                chai.expect(res.body).to.have.property('genreId').eql('1');
                chai.expect(res.body).to.have.property('content').eql([{note: "E1", duration: "4n", timing: 1}, {note: "E5", duration: "8n", timing: 0.5}, {note: "G5", duration: "4n", timing: 0.75}, {note: "E5", duration: "8n", timing: 1.25}, {note: "E5", duration: "8n", timing: 1.75}, {note: "G5", duration: "4n", timing: 1.75}, {note: "F#5", duration: "4n", timing: 2.25}]);
                done();
            });
    });

    it("PATCH /api/v1/genres/:genreId/tunes/:tuneId shall fail when an existing tune is addressed using an incorrect, existing genreId.", function (done) {
        chai.request(apiUrl)
            .patch('/api/v1/genres/1/tunes/3')
            .set('Content-type', 'application/json')
            .send({name: "new name", genreId: '1', content: [{note: "E1", duration: "4n", timing: 1}, {note: "E5", duration: "8n", timing: 0.5}, {note: "G5", duration: "4n", timing: 0.75}, {note: "E5", duration: "8n", timing: 1.25}, {note: "E5", duration: "8n", timing: 1.75}, {note: "G5", duration: "4n", timing: 1.75}, {note: "F#5", duration: "4n", timing: 2.25}] })
            .end((err, res) => {
                chai.expect(res).to.have.status(400);
                chai.expect(res).to.be.json;
                chai.expect(res.body).to.have.property('message').to.be.eql("Tune with id " + '3' + " does not have genre id " + '1' + ".");
                done();
            });
    });

    it("PATCH /api/v1/genres/:genreId/tunes/:tuneId shall fail when a request is made with a non-empty request body that does not contain any valid property for a tune (name, content, genreId).", function (done) {
        chai.request(apiUrl)
            .patch('/api/v1/genres/1/tunes/3')
            .set('Content-type', 'application/json')
            .send({name: "", genreId: '', content: [] })
            .end((err, res) => {
                chai.expect(res).to.have.status(400);
                chai.expect(res).to.be.json;
                chai.expect(res.body).to.have.property('message').to.be.eql("To update a tune, you need to provide a name, a non-empty content array, or a new genreId.");
                done();
            });
    });

    it("PATCH /api/v1/genres/:genreId/tunes/:tuneId shall fail when the tune with the provided id does not exist.", function (done) {
        chai.request(apiUrl)
            .get('/api/v1/genres/0/tunes/999999')
            .set('Content-type', 'application/json')
            .end((err, res) => {
                chai.expect(res).to.have.status(404);
                chai.expect(res).to.be.json;
                chai.expect(res.body).to.have.property('message').to.be.eql("Tune with id " + '999999' + " does not exist.");
                done();
            });
    });
    it("POST /api/v1/genres/:genreId/tunes/ server error 500 response", function (done) {
        chai.request(apiUrl)
            .post('/api/v1/genres/0/tunes/')
            .set('Content-type', 'application/json')
            .send({'name': 'bull' })
            .end((err, res) => {
                chai.expect(res).to.have.status(500);
                done();
            });
    });
    it("POST /api/v1/genres/ replay attack", function (done) {
        chai.request(apiUrl)
            .post('/api/v1/genres')
            .set('Authorization', 'HMAC f1a71952d1c9d661edf9fe8825ee711b6dc07408903de1e763a58baa0eda82fc')
            .send({'genreName': 'Psychedelic Rock' })
            .end((err, res) => {
                chai.expect(res).to.have.status(201);
                done();
            });
    });


});



