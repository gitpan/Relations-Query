# This module is for creating complex select queries with
# Relations.

package Relations::Query;
require Exporter;
require Relations;

use Relations;

# You can run this file through either pod2man or pod2html to produce pretty
# documentation in manual or html file format (these utilities are part of the
# Perl 5 distribution).

# Copyright 2001 GAF-3 Industries, Inc. All rights reserved.
# Written by George A. Fitch III (aka Gaffer), gaf3@gaf3.com

# This program is free software, you can redistribute it and/or modify it under
# the same terms as Perl istelf

# Do the version thing

$Relations::Query::VERSION='0.92';

@ISA = qw(Exporter);

@EXPORT    = ();	

@EXPORT_OK = qw(
                new
                clone
                add
                set
                get 
                get_add
                get_set 
               );

%EXPORT_TAGS = ();

# Be strict

use strict;

# Create a Relations::Query object.

sub new {

  my ($type) = shift;

  # Get all the arguments passed

  my ($select,
      $from,
      $where,
      $group_by,
      $having,
      $order_by,
      $limit) = rearrange(['SELECT',
                           'FROM',
                           'WHERE',
                           'GROUP_BY',
                           'HAVING',
                           'ORDER_BY',
                           'LIMIT'],@_);

  # Create the hash to hold all the vars
  # for this object.

  my $self = {};

  # Bless it with the type sent (I think this
  # makes it a full fledged object)

  bless $self, $type;

  # Add the info into the hash only if it was sent

  $self->{'select'} = as_clause($select);
  $self->{'from'} = as_clause($from);
  $self->{'where'} = equals_clause($where);
  $self->{'group_by'} = comma_clause($group_by);
  $self->{'having'} = equals_clause($having);
  $self->{'order_by'} = comma_clause($order_by);
  $self->{'limit'} = comma_clause($limit);

  return $self;

}

# Creates a copy of the current query

sub clone {

  # Get the self reference first

  my ($self) = shift;

  # Create a new query object using this query
  # object's info

  my ($clone) = new Relations::Query($self->{'select'},
                                     $self->{'from'},
                                     $self->{'where'},
                                     $self->{'group_by'},
                                     $self->{'having'},
                                     $self->{'order_by'},
                                     $self->{'limit'});

  # Return the new object

  return $clone;

}

# Gets the query for the object

sub get {

  # Get the self reference first

  my($self) = shift;

  # Create the string to hold the query

  my ($query) = "" ;

  # Add info where appropriate.

  $query .= length($self->{'select'}) ? "select $self->{'select'} " : "";
  $query .= length($self->{'from'}) ? "from $self->{'from'} " : "";
  $query .= length($self->{'where'}) ? "where $self->{'where'} " : "";
  $query .= length($self->{'group_by'}) ? "group by $self->{'group_by'} " : "";
  $query .= length($self->{'having'}) ? "having $self->{'having'} " : "";
  $query .= length($self->{'order_by'}) ? "order by $self->{'order_by'} " : "";
  $query .= length($self->{'limit'}) ? "limit $self->{'limit'}" : "";
  
  return $query;

}

# Adds data to the existing settings

sub add {
  
  # Get the self reference first

  my ($self) = shift;

  # Get all the other arguments passed

  my ($select,
      $from,
      $where,
      $group_by,
      $having,
      $order_by,
      $limit) = rearrange(['SELECT',
                           'FROM',
                           'WHERE',
                           'GROUP_BY',
                           'HAVING',
                           'ORDER_BY',
                           'LIMIT'],@_);

  # Concatente info into the self hash, prefixing it if there's
  # already something there, only if something's actually been 
  # sent.

  $self->{'select'} = add_as_clause($self->{'select'},$select);
  $self->{'from'} = add_as_clause($self->{'from'},$from);
  $self->{'where'} = add_equals_clause($self->{'where'},$where);
  $self->{'group_by'} = add_comma_clause($self->{'group_by'},$group_by);
  $self->{'having'} = add_equals_clause($self->{'having'},$having);
  $self->{'order_by'} = add_comma_clause($self->{'order_by'},$order_by);
  $self->{'limit'} = add_comma_clause($self->{'limit'},$limit);

}

# Sets the existing settings to whatever's sent

sub set {
  
  # Get the self reference first

  my ($self) = shift;

  # Get all the other arguments passed

  my ($select,
      $from,
      $where,
      $group_by,
      $having,
      $order_by,
      $limit) = rearrange(['SELECT',
                           'FROM',
                           'WHERE',
                           'GROUP_BY',
                           'HAVING',
                           'ORDER_BY',
                           'LIMIT'],@_);

  # Put info into the self hash, only if something's actually been 
  # sent.

  $self->{'select'} = set_as_clause($self->{'select'},$select);
  $self->{'from'} = set_as_clause($self->{'from'},$from);
  $self->{'where'} = set_equals_clause($self->{'where'},$where);
  $self->{'group_by'} = set_comma_clause($self->{'group_by'},$group_by);
  $self->{'having'} = set_equals_clause($self->{'having'},$having);
  $self->{'order_by'} = set_comma_clause($self->{'order_by'},$order_by);
  $self->{'limit'} = set_comma_clause($self->{'limit'},$limit);

}

# Gets the query for the object, and accepts extra parameters
# to temporarily add on to the current parameters.

sub get_add {

  # Get the self reference first

  my ($self) = shift;

  # Create a clone of ourselves

  my ($get_add) = $self->clone();

  # Add the stuff sent to our clone

  $get_add->add(@_);
  
  # Return our fattened clone's query

  return $get_add->get();
                                
}



# Gets the query for the object, and accepts extra parameters
# to temporarily set over the current parameters.

sub get_set {

  # Get the self reference first

  my ($self) = shift;

  # Create a clone of ourselves

  my ($get_set) = $self->clone();

  # set the stuff sent to our clone

  $get_set->set(@_);
  
  # Return our fattened clone's query

  return $get_set->get();
                                
}



$Relations::Query::VERSION;

__END__

=head1 NAME

Relations::Query - Object for building queries with DBI/DBD::mysql

=head1 SYNOPSIS

  # Relations::Query Script that creates some queries.

  use Relations::Query;

  $query = new Relations::Query(-select   => {'fife' => 'barney'},
                                -from     => {'green_teeth' => 'moogoo'},
                                -where    => "flotsam>jetsam",
                                -group_by => "denali",
                                -having   => {'fortune' => 'cookie'},
                                -order_by => ['was','is','will'],
                                -limit    => '1');

  $get_query = $query->get();

  $query->set(-select   => {'clean' => 'sparkle'},
              -from     => {'lean' => 'book'},
              -where    => "fighting is between courage and chaos",
              -limit    => '123');

  $set_query = $query->get();

  $get_add_query = $query->get_add(-select   => {'mean' => 'dog'},
                                   -where    => "running is null",
                                   -having   => {'kitties'=> 'on_tv'},
                                   -limit    => ['9678']);

=head1 ABSTRACT

This perl library uses perl5 objects to simplify the query creation
and manipulation process. It uses an object orientated interface,
complete with functions to manipulate the query and return the 
query as a string.

The current version of Relations::Query is available at

  http://www.gaf3.com
  ftp://ftp.gaf3.com

=head1 DESCRIPTION

=head2 WHAT IT DOES

With Relations::Query you can create a 'select' query by creating a new
query object, and passing hashes, arrays, or strings of info to the 
constructor, such as what's within the variables clause, what to order 
by, etc.  You can also add and override clause info in the query as well, 
on both a permanent and temporary basis. 

=head2 CALLING RELATIONS::QUERY ROUTINES

All standard Relations::Query routines use both an ordered and named 
argument calling style. This is because some routines have as many as 
seven arguments, and the code is easier to understand given a named 
argument style, but since some people, however, prefer the ordered argument 
style because its smaller, I'm glad to do that too.

If you use the ordered argument calling style, such as

  $query = new Relations::Query(['id','label'],'parts');

the order matters, and you should consult the function defintions 
later in this document to determine the order to use.

If you use the named argument calling style, such as

  $query = new Relations::Query(-select => ['id','label'],
                                -from   => 'parts');

the order does not matter, but the names, and minus signs preceeding them, do.
You should consult the function defintions later in this document to determine 
the names to use.

In the named arugment style, each argument name is preceded by a dash.  
Neither case nor order matters in the argument list.  -from, -From, and 
-FROM are all acceptable.  In fact, only the first argument needs to begin with 
a dash.  If a dash is present in the first argument, Relations::Query assumes
dashes for the subsequent ones.

=head2 QUERY ARGUMENTS

All of the Relations::Query object functions require arguments to be used 
as different clauses of a "select * from blah" statements. To be as easy and
flexible as possible (In my opinion anyway! :D ), you can specify these 
arguments as a hash, an array or a string. 

SELECT AND FROM FUNCTIONALITY

If sent as a hash, a select or from argument will become a string of 
'field as name' pairs, concatented with a ','. 

For example,

  $query = new Relations::Query(-select => {'id'     => 'parts.part_id',
                                            'label'  => "concat(parts.name,' - $ ',prices.price)"},
                                -from   => {'parts'  => 'sales.cheap_parts',
                                            'prices' => 'stock.all_prices'});

creates the SQL statment: 

  select parts.part_id as id,concat(parts.name,' - $ ',prices.price) as label 
  from sales.cheap_parts as parts,stock.all_prices as prices

If sent as an array, a select or from argument will become a string of array 
members, concatented with a ','. 

For example,

  $query = new Relations::Query(-select => ['cheap_parts.part_id',
                                            "concat(cheap_parts.name,' - $ ',all_prices.price) as price"],
                                -from   => ['sales.cheap_parts',
                                            'stock.all_prices']);

creates the SQL statment: 

  select cheap_parts.part_id,concat(cheap_parts.name,' - $ ',all_prices.price) as price 
  from sales.cheap_parts,stock.all_prices

If sent as string, a select or from argument will stay a string. 

For example,

  $query = new Relations::Query(-select => "name",
                                -from   => 'sales.cheap_parts');

creates the SQL statment: 

  select name from sales.cheap_parts

WHERE AND HAVING FUNCTIONALITY

If sent as a hash, a where or having argument will become a string of 
'field=value' pairs, concatented with an ' and '. 

For example,

  $query = new Relations::Query(-where  => {'price' => "4.99",
                                            'type'  => "'cap'"},
                                -having => {'total' => '100',
                                            'cost'  => "19.96"});

creates the SQL statment: 

  where price=4.99 and type='cap'
  having total=100 and cost = 19.96

If sent as an array, a where or having argument will become a string of array 
members, concatented with an ' and '. 

For example,

  $query = new Relations::Query(-where  => ['price > 4.99',
                                            "type in ('cap','res','ind')"],
                                -having => ['total between 90 and 100',
                                            'cost=19.96']);

creates the SQL statment: 

  where price > 4.99 and type in ('cap','res','ind')
  having total between 90 and 100 and cost=19.96

If sent as string, a where or having argument will stay a string. 

For example,

  $query = new Relations::Query(-where  => "price > 4.99 or type in ('cap','res','ind')",
                                -having => "total between 90 and 100 or (cost=19.96 and not total=70)");

creates the SQL statment: 

  where price > 4.99 or type in ('cap','res','ind')
  having total between 90 and 100 or (cost=19.96 and not total=70)

GROUP BY, ORDER BY, AND LIMIT FUNCTIONALITY

If sent as a hash, a group by, order by or limit argument will become 
a string of 'field_1,field_2' pairs, concatented with a ','. Why did I 
do this? The clause delimitter is the same for all clauses. So, this 
behavior is more by default than by design. Keep in mind that since 
a hash has no order, the order of your arguments is not guaranteed. 
So, it's really not advisable to pass the "order by" arguments this 
way. You can if you want, but I will you taunt you for doing so.

For example,

  $query = new Relations::Query(-group_by => {'name'     => 'color',
                                              'category' => 'size'},
                                -order_by => {'color'    => 'size',
                                              'name'     => 'category'},
                                -limit    => {'30'  => '5'});

creates the SQL statment: 

  group by name,color,category,size 
  order by color,size,name,category
  limit 30,5

or possibly:

  group by category,size,name,color 
  order by name,category,color,size
  limit 30,5

If sent as an array, a a group by, order by or limit argument will 
become a string of array members, concatented with a ','. 

For example,

  $query = new Relations::Query(-group_by => ['name','color','category','size'],
                                -order_by => ['color','size','name','category'],
                                -limit    => ['30','5']);

creates the SQL statment (without a doubt): 

  group by name,color,category,size 
  order by color,size,name.category
  limit 30,5

If sent as string, a group by, order by or limit argument will stay a 
string. 

For example,

  $query = new Relations::Query(-group_by => 'name,color,category,size',
                                -order_by => 'color,size desc,name,category',
                                -limit    => '30');

creates the SQL statment (without a doubt): 

  group by name,color,category,size 
  order by color,size desc,name.category
  limit 30

=head1 LIST OF RELATIONS::QUERY FUNCTIONS

An example of each function is provided in 'test.pl'.

=head2 new

  $query = Relations::Query->new($select,$from,$where,$group_by,$having,$order_by,$limit);

  $query = new Relations::Query(-select   => $select,
                                -from     => $from,
                                -where    => $where,
                                -group_by => $group_by,
                                -having   => $having,
                                -order_by => $order_by,
                                -limit    => $limit);

Creates creates a new Relations::Query object with each clause stored as
a string.

=head2 clone

  $clone = $query->clone();

Returns creates a copy of a Relations::Query object.

=head2 get

  $query_string = $query->get();

Returns the query in string form.

=head2 add

  $query->add($select,$from,$where,$group_by,$having,$order_by,$limit);

  $query->add(-select   => $select,
              -from     => $from,
              -where    => $where,
              -group_by => $group_by,
              -having   => $having,
              -order_by => $order_by,
              -limit    => $limit);

Adds more info to the query object. If the clause to be added to is already 
set, add() concatenates the new clause onto to current one with the appropriate 
delimitter. If the clause to be added to is not already set, add() sets that 
clause to the new one.

=head2 set

  $query->set($select,$from,$where,$group_by,$having,$order_by,$limit);

  $query->set(-select   => $select,
              -from     => $from,
              -where    => $where,
              -group_by => $group_by,
              -having   => $having,
              -order_by => $order_by,
              -limit    => $limit);

Sets (overwrites) info to the query object. Only the clauses specified will
be over written.

=head2 get_add

  $query->get_add($select,$from,$where,$group_by,$having,$order_by,$limit);

  $query->get_add(-select   => $select,
                  -from     => $from,
                  -where    => $where,
                  -group_by => $group_by,
                  -having   => $having,
                  -order_by => $order_by,
                  -limit    => $limit);

Returns the query, plus whatever's to be added, in string form. The query
object is not added to, but the string is returned with the info added to the
specified clauses.

=head2 get_set

  $query->get_set($select,$from,$where,$group_by,$having,$order_by,$limit);

  $query->get_set(-select   => $select,
                  -from     => $from,
                  -where    => $where,
                  -group_by => $group_by,
                  -having   => $having,
                  -order_by => $order_by,
                  -limit    => $limit);

Returns the query, with the specified clauses over written. The query
object is not overwritten, but the string is returned as if it was.

=head1 OTHER RELATED WORK

=head2 Relations

This perl library contains functions for dealing with databases.
It's mainly used as the the foundation for all the other 
Relations modules. It may be useful for people that deal with
databases in Perl as well.

=head2 Relations::Abstract

A DBI/DBD::mysql Perl module. Meant to save development time and code 
space. It takes the most common (in my experience) collection of DBI 
calls to a MySQL databate, and changes them to one liner calls to an
object.

=head2 Relations::Query

An Perl object oriented form of a SQL select query. Takes hash refs,
array refs, or strings for different clauses (select,where,limit)
and creates a string for each clause. Also allows users to add to
existing clauses. Returns a string which can then be sent to a 
MySQL DBI handle. 

=head2 Relations.Admin.inc.php

Some generalized PHP classes for creating Web interfaces to relational 
databases. Allows users to add, view, update, and delete records from 
different tables. It has functionality to use tables as lookup values 
for records in other tables.

=head2 Relations::Family

A Perl query engine for relational databases.  It queries members from 
any table in a relational database using members selected from any 
other tables in the relational database. This is especially useful with 
complex databases; databases with many tables and many connections 
between tables.

=head2 Relations::Display

An Perl module creating GD::Graph objects from database queries. It 
takes in a query through a Relations::Query object, along with 
information pertaining to which field values from the query results are 
to be used in creating the graph title, x axis label and titles, legend 
label (not used on the graph) and titles, and y axis data. Returns a 
GD::Graph object built from from the query.

=head2 Relations::Choice

An Perl CGI interface for Relations::Family, Reations::Query, and 
Relations::Display. It creates complex (too complex?) web pages for 
selecting from the different tables in a Relations::Family object. 
It also has controls for specifying the grouping and ordering of data
with a Relations::Query object, which is also based on selections in 
the Relations::Family object. That Relations::Query can then be passed
to a Relations::Display object, and a graph or table will be displayed.
A working model already exists in a production enviroment. I'd like to 
streamline it, and add some more functionality before releasing it to 
the world. Shooting for early mid Summer 2001.

=cut