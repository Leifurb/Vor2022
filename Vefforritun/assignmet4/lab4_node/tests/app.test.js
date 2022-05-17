const mod = require('../app');
const chai = require('chai');

describe('Loading files', function () {
  //Some arbitrary timeout. How much?
  this.timeout(10000);

  it('should call the callback with the required resource if a proper URL is provided', function (done) {
    mod.loadFileAsync("https://veff213-minesweeper.herokuapp.com/rules", function (result) {
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