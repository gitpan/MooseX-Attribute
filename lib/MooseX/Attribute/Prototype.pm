package MooseX::Attribute::Prototype;

	use Moose;

	has 'from_role' => (
		is		 	  => 'ro' ,
		isa 	 	  => 'Str' ,
		required 	  => 1 ,
		documentation => "Role from which the attribute prototype is taken" ,
	);

	has 'prototype' => ( 
		is			  => 'rw' , 
		isa			  => 'Str' ,
		required	  => 1 ,
		documentaion  => "Attribute that serves as a prototype" ,
	);

	has 'options' 	=> (
		is			  => 'rw' ,
		isa 		  => 'HashRef' ,
		required	  => 1 ,
		default 	  => sub { {} } ,
		documentation => "The options specifications for the attribute" ,
	);

	has 'referenced' => (
		is			  => 'rw' ,
		isa 		  => 'Bool' ,
		required	  => 1 ,
		default		  => 0 ,
		documentation => "Indicates if the attibute has been referenced as a prototype" , 
	);

	sub get_prototype_options {
		$_[0]->options;	
	} 

	sub key {
		return $_[0]->from_role . "/" . $_[0]->prototype;
	}


	sub get_name_from_key {

		my ( $self, $name ) = @_;
	
		$name =~ s/(.*)\/(.*)/$2/;
		
		return $name;

	}

1;

=pod

=head1 NAME 

MooseX::Attribute::Prototype - An Attribute Prototype Class

=head1 VERSION

0.01

=head1 SYNOPSIS
	
	use MooseX::Attribute::Prototype;

	my $proto = MooseX::Attribute::Prototype->new(
		from_role => 'foo' ,
		prototype => 'bar' 
	);

=head1 DESCRIPTION

This module provides an attribute prototype class.  An 
L<MooseX::Attribute::Prototype> is an object that 

=head1 Attributes

=head2 from_role

=head2 attribute

=head2 options

=head2 is_referenced
		
=cut