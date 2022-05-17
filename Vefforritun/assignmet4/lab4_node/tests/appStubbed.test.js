const mod = require('../app');
const sinon = require('sinon');
const chai = require('chai');

describe('checkAndGetURL(filename)', function () {
  beforeEach(() => {
    var fakeCheck = sinon.fake.returns(true);
    sinon.replace(mod, 'checkURL', fakeCheck);

    var fakeAsync = sinon.fake.yields(null);
    sinon.replace(mod, 'loadFileAsync', fakeAsync);
  });

  it('should return null when a non-existent file is passed in', function (done) {
    mod.checkAndGetURL("invalidFilename.txt", function(returnVal) {
      chai.expect(returnVal).to.equal(null);
      done();
    });
  });

  afterEach(() => {
    sinon.restore();
  });  
});