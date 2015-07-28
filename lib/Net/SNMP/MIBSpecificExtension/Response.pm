package Net::SNMP::MIBSpecificExtension::Response;
use strict;
use warnings;
use Carp ( );
use Net::SNMP::MIBSpecificExtension::Response::Ping;
use Net::SNMP::MIBSpecificExtension::Response::Get;
use Net::SNMP::MIBSpecificExtension::Response::Getnext;
use Net::SNMP::MIBSpecificExtension::Response::Set;

sub new {
    my $class = shift;
    my %param = @_;
    my $method = delete $param{method}
        or Carp::croak( "method required" );
    my $subclass = join q{::}, __PACKAGE__, ucfirst $method;
    my $self = bless \%param, $subclass;
    $self->init;
    return $self;
}

sub init { }

sub as_string { die "override this" }

sub oid {
    my $self = shift;
    if ( @_ ) {
        $self->{oid} = shift;
    }
    return $self->{oid};
}

sub type {
    my $self = shift;
    if ( @_ ) {
        $self->{type} = shift;
    }
    return $self->{type};
}

sub value {
    my $self = shift;
    if ( @_ ) {
        $self->{value} = shift;
    }
    return $self->{value};
}

1;
