package Net::SNMP::MIBSpecificExtension::ObjectDatabase;
use strict;
use warnings;
use Carp ( );

sub new {
    my $class = shift;
    my %param = @_;
    my $base_oid = delete $param{base_oid}
        or Carp::croak( "base_oid required" );
    my $self = bless { %param, base_oid => $base_oid }, $class;
    $self->init;
    return $self;
}

sub init { }

sub db { shift->{db} }

sub base_oid { shift->{base_oid} }

sub get {
    my $self = shift;
    my $oid  = shift
        or return;
    my %object = (
        oid   => $oid,
        type  => $self->db->{ $oid }{type},
        value => $self->db->{ $oid }{value},
    );
    return %object;
}

sub get_next_oid { die "override this" }

sub getnext {
    my $self = shift;
    my $oid  = shift;

    my $next_oid = $self->get_next_oid( $oid );

    return $self->get( $next_oid );
}

sub set {
    my $self = shift;
    my( $oid, $type, $value ) = @_;

    # Do not support `set`

    return "not-writable\n";
}

1;
