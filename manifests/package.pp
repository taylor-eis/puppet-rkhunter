# Class: rkhunter::package
class rkhunter::package
{
  package
  {
    'rkhunter':
      ensure => latest
  }
}
