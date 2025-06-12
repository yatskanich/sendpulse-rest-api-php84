<?php

declare(strict_types=1);

use Rector\Config\RectorConfig;
use Rector\ValueObject\PhpVersion;

return RectorConfig::configure()
    ->withPaths([
        __DIR__ . '/example',
        __DIR__ . '/src',
    ])
    ->withPhpSets(php84: true)
    ->withPhpVersion(PhpVersion::PHP_84)
    ->withTypeCoverageLevel(0)
    ->withDeadCodeLevel(0)
    ->withCodeQualityLevel(0);
