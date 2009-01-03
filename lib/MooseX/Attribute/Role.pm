# BASE CLASS ROLE
package MooseX::Attribute::Role;
	use Moose::Role;
	use Data::Dumper;
	use Perl6::Say; 

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

#			print "\nref role: ";
#			print ref $role;

		  # Copy roles' attribute installs to base class
			if ( $role->meta->get_attribute( 'attribute_installs' ) ) {

#				print "\n AA";
#				print ref $role->attribute_installs;
#				print "\n";		
#				print $role->count_installs;	
#				print "\n";				

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
# print "\nKEY is $key\n";
# print ref $proto;

				}

# print "\nProtos: ";
# print ref $protos;
# print "\n";

			}

#			
#			print "\n";
#			print keys %{$role->meta->get_attribute_map };
#			print "\n\n";
#			# $role->meta->does_role( "MooseX::Attribute::Meta::Role" );		

		}

# print $_[0]->meta->attribute_installs->count;

#		my $r = scalar @{$meta->roles};  # Number of roles.
#		for ( my $i=0; $i<$r; $i++ ) {
#	
#			my $role = $meta->roles->[$i];
#			
#			print "ref role: ";
#			print join " - " , sort keys %{ $role->meta->get_attribute_map };
#
#			# if ( exists ${ $role->meta->get_attribute_map }->{ attribute_installs } ) {
#
#			if ( $role->meta->get_attribute( 'attribute_installs' ) ) {
#				print "\n";
#				print Dumper $role->attribute_installs;
#			}
#
#			print "\n\n";
			

			if ( 0 )  {

# 
#print "yes a\n";
#
#				my $proto = $role->{attribute_prototypes};
#
#				foreach ( keys %$proto ) {
#
#					$meta->{attribute_prototypes}->{$_} =  $proto->{$_} ;
#
#				}
#
#			}
#
# print join "\n", sort keys %$role;
#
#			if ( exists $role->{test_prototypes} ) {
#				print "yes b\n";
#				print join "\n\t" . $role->{test_prototypes}->keys;
#				print Dumper keys %{$role->{test_prototypes}->prototypes };
#				
#			}


		
		}

		$meta->_install_attributes;

	};

	
1;