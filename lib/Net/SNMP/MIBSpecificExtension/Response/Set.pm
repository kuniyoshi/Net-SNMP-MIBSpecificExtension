package Net::SNMP::MIBSpecificExtension::Response::Set;
use strict;
use warnings;
use base "Net::SNMP::MIBSpecificExtension::Response";

sub error {
    my $self = shift;
    if ( @_ ) {
        $self->{error} = shift;
    }
    return $self->{error};
}

sub as_string {
    my $self = shift;

    return "DONE\n"
        unless $self->error;

    return $self->error . "\n";
}

1;
