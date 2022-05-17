let myMod = require('../myModule');
const chai = require('chai');

describe('getSSID', function () {
    it('should return a number', function () {
      chai.expect(myMod.getSSID()).to.be.a('number');
    });
});