
package MooseX::Attribute::Meta::Role;

	our $VERSION = 0.01;

	use Moose::Role;
	
	use MooseX::AttributeHelpers;
	use Data::Dumper;
 
	use MooseX::Attribute::Prototypes;
	has 'attribute_prototypes' => (
		is 			=> 'rw' ,
		isa 		=> 'MooseX::Attribute::Prototypes' ,
		default		=> sub { MooseX::Attribute::Prototypes->new() } ,
		required 	=> 1 , 
		handles	=> [ 'add_prototype', 'get_prototype', 'count_prototypes', 'get_prototype_keys' ],  
	);

=head2 attribute_installs 

This contains the list of attributes that should be installed upon object
construction.  

=cut 

	has attribute_installs => (
		metaclass   => 'Collection::Array' ,
		is 			=> 'rw' ,
		isa			=> 'ArrayRef' ,
		default		=> sub { [] } ,
		required	=> 1 ,
		provides => {
			'push' 	  => 'add_install' ,
			'unshift' => 'get_install' ,
			'count'	  => 'count_installs'       ,
		} ,
	);


  # _install_attributes
  #	  install attributes from $meta->attribute_installs, using the 
  #   prototypes, but overridding any the default definitions
  #
  #  - ctb  
  #
	sub _install_attributes {
		
		foreach my $install ( @{ $_[0]->attribute_installs } ) {

			my $name = $install->{ 'name' } ;

		# If the install does not have a prototype argument add it directly 
			if ( ! $install->{'prototype'} ) {

				$_[0]->add_attribute( $name, $install );

        # Since these do have a prototype option read from the prototype, add it 
        # and mark the prototype as having been referenced.
			}  else {

				my $key = $install->{ 'from_role' } . "/" . $install->{ 'prototype' };
				my $prototype = $_[0]->get_prototype( $key );
				my $options = $prototype->options;

				while( my ($k, $v) = each( %{ $install } ) ) {
					$options->{$k} = $v;
				}

				$_[0]->add_attribute( $name, $options );	

				$prototype->referenced(1);  # Mark this prototype as referenced.

			}

		}


	  # Now we install any of the prototypes that are not referenced.
		foreach ( $_[0]->get_prototype_keys ) {

			my $proto = $_[0]->get_prototype($_);
			my $name = $proto->get_name_from_key( $_ );

			if ( ! $proto->referenced ) {

				$_[0]->add_attribute( $name, $proto->options );

			}

		}
		
	}

1;