<?php

declare(strict_types=1);

namespace App;

final class Calculator
{
    public function add(int $a, int $b): int
    {
        return $a + $b;
    }

    public function one(): int
    {
        return 1;
    }

    public function two(): int
    {
        return 2;
    }

    public function three(): int
    {
        return 3;
    }
}
