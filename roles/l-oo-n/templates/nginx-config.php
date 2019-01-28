<?php
$CONFIG = array (
  'instanceid' => 'oca2dlqe1l2j',
  'passwordsalt' => 'h02pTyuVpkoNEAWzzqzpxi1e3LbfLN',
  'secret' => 'SRiIGDySyLhBbNBxHVcMhyemu9Pd5loMZDycM1kaP8CAHi6v',
  'trusted_domains' =>
  array (
    0 => '{{nextcloud_domain}}',
  ),
  'datadirectory' => '/var/www/nextcloud/data',
  'dbtype' => 'mysql',
  'version' => '15.0.2.0',
  'overwrite.cli.url' => 'https://{{nextcloud_domain}}',
  'dbname' => 'nextcloud',
  'dbhost' => 'localhost',
  'dbport' => '',
  'dbtableprefix' => 'oc_',
  'dbuser' => '{{nextcloud_username}}',
  'dbpassword' => '{{nextcloud_userpass}}',
  'installed' => true,
  'onlyoffice' =>
    array (
      'verify_peer_off' => TRUE,
    )
);
