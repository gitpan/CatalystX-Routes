package CatalystX::Routes::Role::Class;
BEGIN {
  $CatalystX::Routes::Role::Class::VERSION = '0.01';
}

use Moose::Role;
use namespace::autoclean;

has _routes => (
    traits  => ['Hash'],
    isa     => 'HashRef[ArrayRef]',
    handles => {
        add_route   => 'set',
        get_route   => 'get',
        route_names => 'keys',
    },
);

has _chain_points => (
    traits  => ['Hash'],
    isa     => 'HashRef[ArrayRef]',
    handles => {
        add_chain_point   => 'set',
        get_chain_point   => 'get',
        chain_point_names => 'keys',
    },
);

1;
