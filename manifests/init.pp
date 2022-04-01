#
# @summary manages the matterbridge bridge
#
# @param user username that owns the files and runs the service
# @param group group that owns the files and runs the service
# @param manage_user boolean to enable/disable the user+group creation
# @param home home dir for the user
# @param version the desired matterbridge version you want to have
#
# @see https://github.com/42wim/matterbridge
#
# @author Tim Meusel <tim@bastelfreak.de>
#
class matterbridge (
  String[1] $user = 'matterbridge',
  String[1] $group = $user,
  Boolean $manage_user = true,
  String[1] $version = '1.24.1',
  Stdlib::Absolutepath $home = '/opt/matterbridge',
) {
  if $manage_user {
    user { $user:
      ensure         => 'present',
      managehome     => true,
      purge_ssh_keys => true,
      system         => true,
      home           => $home,
      shell          => '/usr/sbin/nologin',
    }
    group { $group:
      ensure => 'present',
      system => true,
    }
  }
}
