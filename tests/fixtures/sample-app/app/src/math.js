/**
 * Additionne deux nombres.
 * @param {number} a
 * @param {number} b
 * @returns {number}
 */
export function sum(a, b) {
  if (typeof a !== 'number' || typeof b !== 'number') {
    throw new TypeError('sum attend deux nombres');
  }
  return a + b;
}
