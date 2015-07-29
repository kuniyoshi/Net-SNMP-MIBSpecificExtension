package Net::SNMP::MIBSpecificExtension;
use 5.8.8;
use strict;
use warnings;
use Carp ( );
use Net::SNMP::MIBSpecificExtension::Request;
use Net::SNMP::MIBSpecificExtension::Response;

sub new {
    my $class = shift;
    my %param = @_;
    my $odb = delete $param{odb}
        or Carp::croak( "odb required" );
    return bless { odb => $odb }, $class;
}

sub odb { shift->{odb} }

sub read_request {
    my $self = shift;
    my $req  = Net::SNMP::MIBSpecificExtension::Request->new;
    return $req;
}

sub handle_ping {
    my $self    = shift;
    my $request = shift;
    my $res = Net::SNMP::MIBSpecificExtension::Response->new( method => "ping" );
    return $res;
}

sub handle_get {
    my $self    = shift;
    my $request = shift;
    my $res = Net::SNMP::MIBSpecificExtension::Response->new( method => "get" );
    my %o = $self->odb->get( $request->oid );
    $res->oid( $o{oid} );
    $res->type( $o{type} );
    $res->value( $o{value} );
    return $res;
}

sub handle_getnext {
    my $self    = shift;
    my $request = shift;
    my $res = Net::SNMP::MIBSpecificExtension::Response->new( method => "getnext" );
    my %o = $self->odb->getnext( $request->oid );
    $res->oid( $o{oid} );
    $res->type( $o{type} );
    $res->value( $o{value} );
    return $res;
}

sub handle_set {
    my $self    = shift;
    my $request = shift;
    my $res = Net::SNMP::MIBSpecificExtension::Response->new( method => "set" );
    my $error = $self->odb->set( $request->oid, $request->type, $request->value );
    if ( $error ) {
        $res->error( $error );
    }
    return $res;
}

sub handle {
    my $self    = shift;
    my $request = shift;
    my %method = (
        ping    => "handle_ping",
        get     => "handle_get",
        getnext => "handle_getnext",
        set     => "handle_set",
    );
    my $method = $method{ $request->method }
        or Carp::croak( "Unknown method given: [", $request->method, "]" );
    return $self->$method( $request );
}

sub loop {
    my $self = shift;

    $|++;

    while ( 1 ) {
        my $request  = $self->read_request;

        last
            unless defined $request; # stdin may be closed.

        my $response = $self->handle( $request );
        print $response->as_string;
    }

    return;
}

1;
