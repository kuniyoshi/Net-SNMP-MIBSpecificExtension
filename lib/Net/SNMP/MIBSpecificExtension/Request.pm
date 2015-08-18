package Net::SNMP::MIBSpecificExtension::Request;
use strict;
use warnings;

sub new {
    my $class = shift;
    my %self;

    $self{method} = <>;

    return
        unless defined $self{method}; # stdin is closed, then parent may finish looping.

    chomp $self{method};
    $self{method} = lc $self{method};

    if ( $self{method} eq "get" ) {
        chomp( $self{oid} = <> );
    }
    elsif ( $self{method} eq "getnext" ) {
        chomp( $self{oid} = <> );
    }
    elsif ( $self{method} eq "set" ) {
        chomp( $self{oid} = <> );
        chomp( my $type_and_value = <> );
        @self{ qw( type value ) } = split m{\s}, $type_and_value, 2;
    }
    elsif ( $self{method} eq "ping" ) {
        ;
    }
    else {
        die "Unknown method found: $self{method}";
    }

    return bless \%self, $class;
}

sub method { shift->{method} }

sub oid { shift->{oid} }

sub type { shift->{type} }

sub value { shift->{value} }

1;
