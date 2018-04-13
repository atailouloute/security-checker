#!/usr/bin/env php
<?php

require __DIR__ . '/vendor/autoload.php';

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Style\SymfonyStyle;
use SensioLabs\Security\SecurityChecker;
use Symfony\Component\Console\Application;

class SecurityCheckerCommand extends Command
{
    protected static $defaultName = 'security:check';

    protected function configure()
    {
        $this->addArgument('lock_file', InputArgument::REQUIRED);
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $io = new SymfonyStyle($input, $output);
        $vulnerabilities = (new SecurityChecker())->check($input->getArgument('lock_file'));

        if (empty($vulnerabilities)) {
            $io->success('Everything is OK');
        } else {
            $io->error('Vulnerabilities detected!');
            $io->error(json_encode($vulnerabilities, JSON_PRETTY_PRINT));
        }
    }
}

$app = new Application();
$app->add(new SecurityCheckerCommand);
$app->run();