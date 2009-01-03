package main;

	
	use Test::More tests => 15;

	use_ok 'MooseX::Attribute::Prototype';
	use_ok 'MooseX::Attribute::Prototypes';

	my $o = MooseX::Attribute::Prototype->new( 
		from_role => 'foo' ,
		prototype => 'bar' ,
	); 
	isa_ok( $o, "MooseX::Attribute::Prototype" );

	my $p = MooseX::Attribute::Prototype->new( 
		from_role => 'fooz' ,
		prototype => 'baz' ,
	);
	isa_ok( $p, "MooseX::Attribute::Prototype" );

	ok( $o->from_role eq 'foo', 'from_role' );
	ok( $o->prototype eq 'bar', 'attribute' );


# COLLECTION 
	diag( "Testing Collection" );
	my $oo = MooseX::Attribute::Prototypes->new();
	isa_ok( $oo, 'MooseX::Attribute::Prototypes' );

	ok( $oo->count ==  0, "Empty prototypes collection" ); # 0

	$oo->add_prototype( $o );
	ok( $oo->count == 1, "One prototype added" );

	$oo->add_prototype( $o );
	ok( $oo->count == 1, "Clobbered prototype" );

	$oo->add_prototype( $p);
	ok( $oo->count == 2, "Second prototype added"  );
 
	ok( $oo->exists( from_role => "foo", prototype => "bar" ), "Collection exists" );	
	ok( ! $oo->exists( from_role => "foo", prototype => "fail" ), "Not Collection exists" );	
	
	isa_ok( $oo->get_prototype( from_role => 'foo', prototype=>'bar' ), 'MooseX::Attribute::Prototype' );
	isa_ok( $oo->get_prototype( from_role => 'fooz', prototype => 'baz' ), 'MooseX::Attribute::Prototype' );
	
	
__END__
