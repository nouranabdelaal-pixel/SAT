<?php

declare(strict_types=1);

namespace Tests;

use App\Calculator;
use PHPUnit\Framework\TestCase;

final class CalculatorTest extends TestCase
{
    public function testAdd(): void
    {
        $this->assertSame(4, (new Calculator())->add(1, 2));
    }
}
