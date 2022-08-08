<?php

namespace App\Dto;

final class CarOutput
{
    public function __construct(public int $id, public string $color)
    {
    }
}