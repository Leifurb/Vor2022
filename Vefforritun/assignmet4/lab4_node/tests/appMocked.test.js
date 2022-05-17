const mod = require('../app');
const nock = require('nock');
const chai = require('chai');

describe('Loading files', function () {
  beforeEach(() => {
    nock('http://veff213-sudoku.herokuapp.com')
      .get('/test')
      .reply(200, "Backend is online.");
  });

  it('should call the callback with the required resource if a proper URL is provided', function (done) {
    mod.loadFileAsync("http://veff213-sudoku.herokuapp.com/test", function (result) {
      chai.expect('Backend is online.').to.equal(result);
      done();
    });
  });

  it('should call the callback with null in case the URL is invalid or the HTTP request is not successful', function (done) {
    mod.loadFileAsync("doesNotExist.txt", function (result) {
      chai.expect(null).to.equal(result);
      done();
    });
  });

});