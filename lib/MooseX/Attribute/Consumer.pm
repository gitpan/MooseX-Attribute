# Package to be used by the _CONSUMER_ of attributes, usually a Moose class
# This controls the metaclass and properties to 
package MooseX::Attribute::Consumer;

	use Moose::Role;
	use Moose::Exporter;
	use Moose::Util::MetaRole;
	use Moose::Util qw/:all/;

	Moose::Exporter->setup_import_methods(); # This is necessary for init_meta
											 # to work properly.

  # Install the base_class and metaclass roles to _CONSUME_ prototype attributes	
	sub init_meta {
		
		my ( $caller, %options ) = @_;

		Moose::Util::MetaRole::apply_base_class_roles( 
			for_class 	=> $options{for_class},
			roles		=> [ 'MooseX::Attribute::Role' ] ,
		);

		Moose::Util::MetaRole::apply_metaclass_roles(
			for_class		=> $options{for_class} ,
			metaclass_roles => [ 'MooseX::Attribute::Meta::Role' ]  
		);

	}

    # sub attribute { print "yes" }; 






=pod

=head1 NAME

MooseX::Attribute::Consumer - borrow and extend attributes from (other) Moose::Roles

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 CAVEAT

B<This is still an experimental module and should not be used in 
production systems.  It is very, very likely to change when vetted 
against members of #Moose and moose@perl.org.  The parts that may
change are:>

=head1 SYNOPSIS

	package MyRole;
	use Moose;
	use MooseX::Attribute::Consumer; # Now go get them
 	use MooseX::Attribute;

		attribute infile => ( 
			from_role => 'MyRole' ,
			prototype => 'file' 
			required  => 1
		);

		...

	package main;

		MyApp->new( infile => '/tmp/data' );

 
=head1 DESCRIPTION 

MooseX::Attribute::Consumer is the class that allows for a class to import 
and extend prexisitng Moose attributes have been defined in Moose roles.  
C<attribute> is used instead of C<has> and the attribute options 
C<from_role> and C<prototype> are used to identify which role and which 
attribute to use as a prototype.

Details are in L<MooseX::Attribute>


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

L<MooseX::Attribute> Module for roles that provide attributes.

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

Copyright 2008 Open Data Group, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of MooseX::Attribute
