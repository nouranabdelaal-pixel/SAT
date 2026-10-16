const assert = require('assert');
const { add } = require('../index');

describe('add', () => {
  it('adds', () => { assert.strictEqual(add(1, 2), 4); });
});
