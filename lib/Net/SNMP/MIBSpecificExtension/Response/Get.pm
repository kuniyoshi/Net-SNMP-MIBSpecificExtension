package Net::SNMP::MIBSpecificExtension::Response::Get;
use strict;
use warnings;
use base "Net::SNMP::MIBSpecificExtension::Response";

sub as_string {
    my $self = shift;

    return "NONE\n"
        if grep { !defined $_ } ( $self->oid, $self->type, $self->value );

    return join "\n", $self->oid, $self->type, $self->value, q{};
}

1;
