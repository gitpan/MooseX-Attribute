use strict;
use warnings;

use Test::More tests => 5;

{ 
	# test role.  uses has. This gets built into the module exactly as specified.
	package basic_role_1;

		use Moose::Role;
	
		has basic_attr => ( 
			is => 'rw', 
			isa => 'Str', 
			default => 'basic stuff' 
		);
}


{
	# Test role.  Unreferenced attribute
	#   Here 'attribute' specifies a attribute, but this attribute does not serve
	#   as a prototype for any other attribute.  It gets installed as defined. 

	package derived_role_2;
	
		use Moose::Role;
		use MooseX::Attribute;

		attribute adv_attr => ( 
			is => 'rw', 
			isa => 'Str', 
			default => 'adv stuff', 
			required=>1 
		);
}

{ 
	package MyApp::Attribute;

	use Moose::Role;
	use MooseX::Attribute;

	attribute 'file' => ( 
		is => 'ro', 
		isa => 'Str',
		documentation => 'borrowed' 
	);

	attribute 'date' => ( 
		is 		=> 'rw' ,
		isa 	=> 'Int' ,
		documentation => 'Unused'
	); 
}

{
	# In this case, we add the attribute if there is no prototype using it.
	# This is the package that _consumes an attribute_
	# Attribute: Consumer.

	package MyApp;

		use Moose;
		use MooseX::Attribute::Consumer; 
		use MooseX::Attribute; # Provides Attribute sugar 
			with 'basic_role_1';
			with 'derived_role_2';
			with 'MyApp::Attribute';
	
	attribute name => ( is => 'rw', isa => 'Str' );
	
	# This is used just as has would be used.
	# Consuming attribute: 

	attribute foo => ( 
		# is 		  => 'rw', 
		# isa 		  => 'Str', 
		default 	  => 'MyApp/foo',
		prototype	  => 'file' ,
		from_role	  => 'MyApp::Attribute',
		documentation => '...Foo Attribute...' ,
	);

	attribute bar => ( 
		is 			  => 'rw', 
		isa 		  => 'Str', 
		default 	  => 'MyApp/bar',
		prototype	  => 'date' ,
		from_role	  => 'MyApp::Attribute',
		documentation => 'using proto for red' ,
	);

	no MooseX::Attribute;
}


package main; 
	
	use Perl6::Say;
	use Data::Dumper;
	

	my $o = MyApp->new( 
		name => 'Main/Foo', 
		# blue=> 'This is the blue attr' 
	);


	ok( $o->name eq 'Main/Foo', 'Attribute set during new from main package' );
	ok( $o->bar eq 'MyApp/bar', 'Attribute MyApp/bar overrides MyApp::Attribute/file' );	
	ok( $o->foo eq 'MyApp/foo', 'Attribute MyApp/foo overrides MyApp::Attribute/file' );
	ok( $o->basic_attr eq 'basic stuff', 'Attribute declared using _has_ in role' );
	ok( $o->adv_attr eq 'adv stuff', 'Attribute declared using _attribute_ in role' );

	# say $o->meta->get_attribute("bar")->default;
	# say Dumper $o->meta->test_prototypes;
		