# BASE CLASS ROLE
package MooseX::Attribute::Role;
	use Moose::Role;
	use Data::Dumper;

  # method modifier: before new
  #   Prior to construction of the object, we need to gather all prototype 
  #   definitions. These exist in class and each of the roles consumed by the class
  #   These are added to the $meta->attribute_prototypes slot
  #	  for easier construction. 
  # - ctb
	before 'new' => sub { 

		my $meta = $_[0]->meta;
		
	  # Search roles for attribute_installs ... move them into the base class
	  # There seems to be no Moose function that identifies all the atributes 
	  # provided by consumed roles.  We do this manually.  
      # - ctb
		foreach my $role ( @{$meta->roles} ) {


		  # Copy roles' attribute installs to base class
			if ( $role->meta->get_attribute( 'attribute_installs' ) ) {

				foreach my $install ( @{ $role->attribute_installs } ) {
					print "Installing ... \n";
					# print Dumper $install;
					$meta->add_install( $install );
				}

			}

		  # Copy roles' attribute prototypes to base class
			if ( $role->meta->get_attribute( 'attribute_prototypes' ) ) {
				
				foreach my $key ( $role->get_prototype_keys ) {
					
					my $proto = $role->get_prototype( $key );
					$meta->add_prototype( $proto );

				}

			}

		}

		$meta->_install_attributes;

	};

	
1;
