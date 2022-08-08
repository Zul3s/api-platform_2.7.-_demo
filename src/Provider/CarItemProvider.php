<?php

namespace App\Provider;

use ApiPlatform\Metadata\Operation;
use ApiPlatform\State\ProviderInterface;
use App\Dto\CarOutput;

final class CarItemProvider implements ProviderInterface
{
    public function provide(Operation $operation, array $uriVariables = [], array $context = [])
    {
        return array(new CarOutput(1, 'red'), new CarOutput(2, 'blue'));
    }
}