# Class: rkhunter::exec
class rkhunter::exec
{
  exec
  {
    'RKHunter_Update':
      command     => 'rkhunter --update',
      path        => '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin',
      tries       => 2, # It failes if there are updates after install, running it twice will make sure it's updated.
      before      => Exec['RKHunter_Propupd'],
      #refreshonly => true
      onlyif => '/usr/bin/test ! -f /var/lib/rkhunter/db/rkhunter.dat',
  }
  exec
  {
    'RKHunter_Propupd':
      command     => 'rkhunter --propupd',
      path        => '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin',
      subscribe   => Exec['RKHunter_Update'],
      before      => Exec['RKHunter_Scan'],
      refreshonly => true
  }
  exec
  {
    'RKHunter_Scan':
      command     => 'rkhunter --cronjob --report-warnings-only',
      path        => '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin',
      tries       => 2, # First try failes because of /etc/passwd and /etc/group files, which are added to database after first rkhunter scan
      require     => File[$rkhunter::configDefault],
      subscribe   => Exec['RKHunter_Propupd'],
      refreshonly => true
  }
}
