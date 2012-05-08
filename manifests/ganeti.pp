class ganeti_tutorial::ganeti::install {
    require ganeti_tutorial::params

    $ganeti_version = "${ganeti_tutorial::params::ganeti_version}"

    file {
        "/etc/init.d/ganeti":
            ensure  => present,
            require => Exec["install-ganeti"],
            source  => "/root/src/ganeti-${ganeti_version}/doc/examples/ganeti.initd",
            mode    => 755,
    }

    ganeti_tutorial::unpack {
        "ganeti":
            source      => "/root/src/ganeti-${ganeti_version}.tar.gz",
            cwd         => "/root/src/",
            creates     => "/root/src/ganeti-${ganeti_version}",
            require     => File["/root/src"];
    }

    exec {
        "install-ganeti":
            command => "/vagrant/modules/ganeti_tutorial/files/scripts/install-ganeti",
            cwd     => "/root/src/ganeti-${ganeti_version}",
            creates => "/usr/local/sbin/gnt-cluster",
            require => [ Ganeti_tutorial::Unpack["ganeti"], Package["ghc6"],
                        Package["libghc6-json-dev"],
                        Package["libghc6-network-dev"],
                        Package["libghc6-parallel-dev"],
                        Package["libghc6-curl-dev"], ];
    }

    service {
        "ganeti":
            enable      => true,
            require     => File["/etc/init.d/ganeti"],
    }
}

class ganeti_tutorial::ganeti::initialize inherits ganeti_tutorial::ganeti::install {
    exec {
        "initialize-ganeti":
            command => "/vagrant/modules/ganeti_tutorial/files/scripts/initialize-ganeti",
            creates => "/var/lib/ganeti/config.data",
            require => [
                Exec["install-ganeti"], Exec["ifup_br0"], Exec["ifup_eth2"],
                Exec["modprobe_drbd"], ],
    }
}
