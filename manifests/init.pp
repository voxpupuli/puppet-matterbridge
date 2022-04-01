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
  file { "${home}/matterbridge-${version}-linux-64bit":
    source => "https://github.com/42wim/matterbridge/releases/download/v${version}/matterbridge-${version}-linux-64bit",
    owner  => $user,
    group  => $group,
    mode   => '0770',
  }
  file { '/usr/local/bin/matterbridge':
    ensure => 'link',
    target => "/opt/matterbridge/matterbridge-${version}-linux-64bit",
    notify => Service['matterbridge.service'],
  }

  # lint:ignore:strict_indent
  $unit = @("UNIT"/L)
  # THIS FILE IS MAINTAINED BY PUPPET
  [Unit]
  Description=Matterbridge Server
  After=network-online.target

  [Service]
  ExecStart=/usr/local/bin/matterbridge -debug -conf ${home}/matterbridge.toml
  TimeoutStartSec=3600
  Restart=on-failure
  RestartSec=5s
  WorkingDirectory=${home}
  User=matterbridge
  Group=matterbridge
  Type=simple
  CapabilityBoundingSet=
  AmbientCapabilities=
  NoNewPrivileges=true
  #SecureBits=
  ProtectSystem=strict
  ProtectHome=true
  PrivateTmp=true
  PrivateDevices=true
  PrivateNetwork=false
  PrivateUsers=true
  ProtectHostname=true
  ProtectClock=true
  ProtectKernelTunables=true
  ProtectKernelModules=true
  ProtectKernelLogs=true
  ProtectControlGroups=true
  RestrictAddressFamilies=AF_UNIX AF_INET AF_INET6
  RestrictNamespaces=true
  LockPersonality=true
  RestrictRealtime=true
  RestrictSUIDSGID=true
  #SystemCallFilter=@system-service
  #SystemCallArchitectures=native

  [Install]
  WantedBy=multi-user.target
  | UNIT
  # lint:endignore:strict_indent

  systemd::unit_file { 'matterbridge.service':
    active  => true,
    enable  => true,
    content => $unit,
  }
}
