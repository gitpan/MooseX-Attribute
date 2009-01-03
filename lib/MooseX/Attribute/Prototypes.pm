# Collection Class for prototypes;
# 	Key is role/prototype
#		
package MooseX::Attribute::Prototypes;

	our $VERSION = 0.01;

	use Moose;
	use MooseX::AttributeHelpers;

	has 'prototypes' => (
		is			  => 'rw' ,
		isa			  => 'HashRef[MooseX::Attribute::Prototype]' ,
		# isa			  => 'HashRef[Str]' ,
		default		  => sub { {} } ,
		documentation => 'Slot containing hash of attribute prototypes' ,
		metaclass 	  => 'Collection::Hash' ,
		provides	  => {
			set 	=> '_set_prototype' ,
			get 	=> '_get_prototype' ,
			count	=> 'count' , 	
			exists	=> 'exists' ,
			keys	=> 'keys' ,
		} ,
		# handles 	=> { 
		#	count	=> 'count_prototypes' 
		# } ,# the object handles these functions.  
	);
			

    # Since we 
	sub add_prototype {
		
		my ( $self, $prototype ) = @_;

#		print  "Adding: " .  $prototype->key;
#		print "\n";
		$self->_set_prototype( 
			$prototype->key ,
			$prototype 
		);

	} 

	sub set_prototype { add_prototype( @_ ); }


	sub get_prototype {

		my ( $self, @opts ) = @_;

#		confess( "To get_prototype you must specify from_role and attribute.\n")
#			if ( ! $opts{from_role} || ! $opts{attribute});
#
		$self->_get_prototype( $self->make_key( @opts ) );

	}
 

   	# Since the key is built from multiple attributes from each object, 
	# we can use 'around' method modifier to build the proper key before
	# delegating. 
    around 'exists' => sub { 

		my ( $exists_ref, $self, @args  ) = @_;  

		my $key = $self->make_key( @args );
		$self->$exists_ref( $key );

	};
		

  # Given from_role, attribute makes a key.	
	sub make_key {
	
		if ( @_ == 2 ) {
			return $_[1];
		} else {
			my %opts = @_[1..4];
			return ( $opts{ from_role } . '/' . $opts{ prototype } );
		}

	}

  # set the reference property of the attribute described by key
	sub set_referenced { 

		my $self = shift;
		my $key  = @_;

		my $prototype = $self->get_prototype( $key );
		$prototype->referenced = 1;
		
	}

	sub get_prototype_keys {

		my $self = shift;
		
		return $self->keys;

	}

1;	

=pod

=head1 NAME

MooseX::Attribute::Prototypes - Collection Class for MooseX::Attribute::Prototype

=head1 VERSION 

0.01

=head1 SYNOPSIS

	use MooseX::Attribute::Prototypes
	$collection = MooseX::Attribute::Prototypes->new();

	# Add a prototype
	$collection->add_prototype( $prototype );


	# Retrieve a prototype from the collections
	$collection->get_prototype( from_role => 'MyRole', attribute => 'file' );
	
	# Check if a prototype exists
	$collection->exists( from_role => 'MyRole', attribute => 'file' );

	
