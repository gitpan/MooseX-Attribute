package MooseX::Attribute;

our $VERSION = '0.02';


use warnings;
use strict;
use Moose;
use Moose::Exporter;
use Moose::Util qw/:all/;
use MooseX::Attribute::Prototype;
	
Moose::Exporter->setup_import_methods(
	with_caller => [ 'attribute' ] ,
);
	
  # For any caller, we want to install a slots to store the attribute 
  # prototypes and attributes installs.  The actual installation
  # will be deferred until before new is called on the object.
	sub init_meta {
		
		my ( $caller, %options ) = @_;

		Moose::Util::MetaRole::apply_metaclass_roles(
			for_class		=> $options{for_class} ,
			metaclass_roles => [ 'MooseX::Attribute::Meta::Role' ]  
		);

	}


=head1 NAME

MooseX::Attribute - create extendable and reusable attributes 

=head1 VERSION

Version 0.02

=cut


=head1 CAVEAT

B<This is still an experimental module and should not be used in 
production systems.  It is very, very likely to change.  The parts that may
change are:>

	- package name(s): 
	
	- attribute(sugar) names: 
	  seems like a bad name ... has_? or just replace has 

=head1 SYNOPSIS

Create a prototype attribute

	package MyRole;
	use Moose::Role;
	use MooseX::Attribute;
	
		attribute file => (
			is		=> 'ro' 	,
			isa		=> 'Str'	,
			required=> 0 
		);

	no MooseX::Attribute;

Then in your class, borrow that attribute

	package MyApp;
	use Moose;
    use MooseX::Attribute::Consumer;
		with 'MyRole';

	attribute infile => ( 
		from_role => 'MyRole' ,
		prototype => 'file' 
		required  => 1
	);

	...

	package main;

		MyApp->new( infile => '/tmp/data' );


 
=head1 DESCRIPTION 

MooseX::Attribute provides Moose sugar to abstract, import and extend 
Moose attributes.  Already, types have been made abstracted by
L<MooseX::Types>.  Roles have been abstracted by
L<MooseX::Role::Parameterized>.  This is just an extension of those 
abstractions applied to attributes.  

Adding attributes to class should be easy as an import statement.  
Most attributes are very recurring, e.g. a date attribute, a file 
attribute or a URI attribute.  Nonetheless, these are often re-coded for 
each application.  This module presents a mechanism to 
obviate that recoding.

In most cases and with sensible defaults specifications.  Nothing need 
be changed to get a fully functional attribute.  When these defaults 
are inadequate, overriding and extending is easy and follows existing 
attribute. The developer need not know the complete specification for 
the behaviors of the attributes, he only need worry about the deltas! 

There are several goals:

	1. Make attribute specifications (more) reusable  
	
	2. Make it easy/easier to 'Moosify' existing CPAN modules/objects as 
	   Moose attributes.
	
	3. Use Moose and follow the Moose design closely.


=head1 EXPORT

=head2 attribute

C<attribute> is Moose sugar word that allows you to import and extend 
Moose attributes that are defined in Moose roles.  For most purposes, 
you can use C<attribute> in place.  See L<#LIMITATIONS> for when this 
breaks. 

	has attr_1 => ( ... );
	
	attribute attr_2 => ( ... );


C<attribute> can be used in all(?) four attribute situations:

	1. The attribute is specified directly in the consuming class just
	   as 'has' is used.  No other attribute references this attribute.
	
	2. The attribute is defined in in a Moose role consumed by the class/ 
	   No other attributes references this attribute as a prototype.
	
	3. The attribute specified another attribute as its prototype. The
	   prototype lives in the same package.
	
	4. The attribute specifies another attribute as its prototype.  The 
	   prototype lives in another package.

=cut
	
	sub attribute {

		my ( $caller, $name, %options ) = @_;

      # Note this is the meta of the caller and not necessarily the meta of 
      # the object. This will either be Moose::Meta::Role or Class::MOP::Class::__ANON__
	  # There are not necessarily *prototypes and *install objects
      # here.  These should be initialized in these classes if they do not exist.      
		my $meta = find_meta( $caller );

      # If the attribute specifies a prototype to reference, we know that 
      # that it should be installed as an attribute.  Otherwise add it to
	  # the list of prototypes, which will be installed if not referenced.

		if ( exists $options{'prototype'} ) {

			$options{ name } = $name;
			$meta->add_install( \%options );

		} else {
			 
			my $p = MooseX::Attribute::Prototype->new( 
				from_role => $caller , 
				prototype => $name ,
				options   => \%options ,
			);
		  
			# print $meta->attribute_installs;
			# $meta->add_install( \%options );
			$meta->add_prototype( $p );

		}
	
	}


=head1 HOW IT WORKS

C<attribute> delays the building of attributes.  Instead, it keeps a 
list of C<attribute_prototypes> and C<attribute_installs>.  A method 
modifier is then used to define these attribute prior to the class 
being initialized.  This is similar to how roles are dealt with.  In 
fact, although not done in this module, it would allow you to create 
methods that could apply options to all attributes in a single method 
call.  At present, I do not believe this is (easily) possible.

=head1 LIMITATIONS

At present, simultaneously consuming an attribute from a role and using 
it as a prototype cannot work.  The straight consumption will be 
overlooked.  If you use an attribute as a prototype, all uses of that 
attribute must follow the prototype specification.

=head1 SEE ALSO

L<MooseX::Attribute::Consumer> Module for consuming prototype roles.

=head1 AUTHOR

Christopher Brown, C<< <ctbrown at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-moosex-attribute at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=MooseX-Attribute>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc MooseX::Attribute

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=MooseX-Attribute>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/MooseX-Attribute>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/MooseX-Attribute>

=item * Search CPAN

L<http://search.cpan.org/dist/MooseX-Attribute>

=back


=head1 ACKNOWLEDGEMENTS

Though they would probably cringe to hear it, this effort would not have 
been possible without: 

Shawn Moore

David Rolsky

Thomas Doran

Stevan Little


=head1 COPYRIGHT & LICENSE

Copyright 2008 Christopher Brown and Open Data Group L<http://opendatagroup.com>, 
all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of MooseX::Attribute
