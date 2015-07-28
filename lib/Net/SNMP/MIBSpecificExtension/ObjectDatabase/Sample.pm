package Net::SNMP::MIBSpecificExtension::ObjectDatabase::Sample;
use strict;
use warnings;
use base "Net::SNMP::MIBSpecificExtension::ObjectDatabase";

use constant STRING  => "string";
use constant COUNTER => "counter";

my %DATABASE = (
    "1.1" => { type => STRING,  value => "sampleCounter" },
    "1.2" => { type => COUNTER, value => 10 },
);

sub init {
    my $self = shift;
    my $base_oid = $self->base_oid;
    my @keys   = keys %DATABASE;
    my @values = values %DATABASE;
    @keys = map { "$base_oid.$_" } @keys;
    my %db;
    @db{ @keys } = @values;
    $self->{db} = \%db;
    return;
}

sub update {
    my $self = shift;
    my $db_ref = $self->db;
    my $base_oid = $self->base_oid;
    $db_ref->{ "$base_oid.1.2" }{value}++;
    return;
}

sub get {
    my $self = shift;
    my $oid  = shift;
    $self->update;
    return $self->SUPER::get( $oid );
}

sub get_next_oid {
    my $self = shift;
    my $oid  = shift;
    my $base_oid = $self->base_oid;
    return "$base_oid.1.1"
        if $oid eq "$base_oid.1";
    return "$base_oid.1.2"
        if $oid eq "$base_oid.1.1";
    return;
}

sub getnext {
    my $self = shift;
    my $oid  = shift;
    $self->update;
    return $self->SUPER::getnext( $oid );
}

1;
