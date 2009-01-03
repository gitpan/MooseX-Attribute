use Test::More tests => 6;

{
package MyClass;
		use Test::More;
		use_ok 'Moose';
		use_ok 'MooseX::Attribute::Consumer';
		use_ok 'MooseX::Attribute::Prototype';

}


package main;

	use Data::Dumper;
	my $o = MyClass->new;
	my $meta = $o->meta;

	isa_ok( $meta->attribute_prototypes,'MooseX::Attribute::Prototypes' );
	ok( $meta->attribute_prototypes->count == 0, "Correct Count" );
	
	my $p = MooseX::Attribute::Prototype->new( 
		from_role => 'MyRole', 
		prototype => 'MyAttribute'
	);

	
	$meta->add_prototype( $p ); 
	ok( $meta->attribute_prototypes->count == 1, "Correct Count" );

	# print ref $meta->attribute_installs;