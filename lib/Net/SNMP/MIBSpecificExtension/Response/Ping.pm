package Net::SNMP::MIBSpecificExtension::Response::Ping;
use strict;
use warnings;
use base "Net::SNMP::MIBSpecificExtension::Response";

sub as_string { "PONG\n" }

1;
