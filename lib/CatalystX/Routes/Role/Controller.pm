package CatalystX::Routes::Role::Controller;
BEGIN {
  $CatalystX::Routes::Role::Controller::VERSION = '0.01';
}

use Moose::Role;
use namespace::autoclean;

requires 'register_actions';

after register_actions => sub {
    my $self = shift;
    my $c    = shift;

    for my $route ( $self->meta()->route_names() ) {
        my ( $attrs, $method ) = @{ $self->meta()->get_route($route) };

        $self->_add_cx_routes_action( $c, $route, $attrs, $method->body() );
    }

    for my $chain_point ( $self->meta()->chain_point_names() ) {
        my ( $attrs, $code )
            = @{ $self->meta()->get_chain_point($chain_point) };

        $self->_add_cx_routes_action( $c, $chain_point, $attrs, $code );
    }
};

sub _add_cx_routes_action {
    my $self  = shift;
    my $c     = shift;
    my $name  = shift;
    my $attrs = shift;
    my $code  = shift;

    my $class     = $self->catalyst_component_name;
    my $namespace = $self->action_namespace($c);

    for my $key ( keys %{$attrs} ) {
        my $parse_meth = "_parse_${key}_attr";

        next unless $self->can($parse_meth);

        ( undef, my $value )
            = $self->$parse_meth( $c, $name, $attrs->{$key} );

        $attrs->{$key} = [$value];
    }

    my $reverse = $namespace ? "${namespace}/$name" : $name;

    my $action = $self->create_action(
        name       => $name,
        code       => $code,
        reverse    => $reverse,
        namespace  => $namespace,
        class      => $class,
        attributes => $attrs,
    );

    $c->dispatcher->register( $c, $action );
}

1;
