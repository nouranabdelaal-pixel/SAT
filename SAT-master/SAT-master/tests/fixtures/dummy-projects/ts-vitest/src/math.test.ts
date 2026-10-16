import { describe, expect, it } from 'vitest';
import { add } from './math';

describe('math', () => {
  it('adds', () => { expect(add(1, 2)).toBe(3); });
});
