import { test } from 'node:test';
import assert from 'node:assert/strict';
import { sum } from './math.js';

test('sum additionne deux nombres', () => {
  assert.equal(sum(2, 3), 5);
});

test('sum rejette les valeurs non numériques', () => {
  assert.throws(() => sum('2', 3), TypeError);
});
