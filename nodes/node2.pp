$host_ip = "33.33.33.12"
$drbd_ip = "33.33.34.12"

include ganeti_tutorial
include ganeti_tutorial::networking
include ganeti_tutorial::kvm
include ganeti_tutorial::instance_image
include ganeti_tutorial::ganeti::install
#include ganeti_tutorial::htools

File { owner => "root", group => "root", }
