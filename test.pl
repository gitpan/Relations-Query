use Relations::Query;

$query_one = "select barney as fife " . 
             "from moogoo as green_teeth ".
             "where flotsam>jetsam " .
             "group by denali " .
             "having fortune=cookie " .
             "order by was,is,will ".
             "limit 1";
    
$query = new Relations::Query(-select   => {'fife' => 'barney'},
                              -from     => {'green_teeth' => 'moogoo'},
                              -where    => "flotsam>jetsam",
                              -group_by => "denali",
                              -having   => {'fortune' => 'cookie'},
                              -order_by => ['was','is','will'],
                              -limit    => '1');

$get_query = $query->get();

#print "get_query: '$get_query'\nquery_one: '$query_one'\n\n";

die "Query new or get failed" unless ($get_query eq $query_one);
 
$clone = $query->clone();

$clone_query = $clone->get();

#print "get_query: '$get_query'\nclone_query: '$clone_query'\n\n";

die "Query clone failed" unless ($get_query eq $clone_query);
 
$query_two = "select barney as fife,aunt as bee " . 
             "from moogoo as green_teeth,fish as sea ".
             "where flotsam>jetsam and lighter=dark " .
             "group by denali,sally,merman " .
             "having fortune=cookie and sushi<wasabe " .
             "order by was,is,will,n,cheese ".
             "limit 1,2";
    
$query->add(-select   => {'bee' => 'aunt'},
            -from     => {'sea' => 'fish'},
            -where    => {'lighter' => 'dark'},
            -group_by => ['sally','merman'],
            -having   => "sushi<wasabe",
            -order_by => {'n' => 'cheese'},
            -limit    => '2');

$add_query = $query->get();

#print "query_two: '$query_two'\nadd_query: '$add_query'\n\n";

die "Query add failed" unless ($query_two eq $add_query);
 
$query_thr = "select sparkle as clean " . 
             "from book as lean ".
             "where fighting is between courage and chaos " .
             "group by a,raging,fire " .
             "having fishes in (the sea) " .
             "order by sense,faith,passion ".
             "limit 123";
    
$query->set(-select   => {'clean' => 'sparkle'},
            -from     => {'lean' => 'book'},
            -where    => "fighting is between courage and chaos",
            -group_by => ['a','raging','fire'],
            -having   => "fishes in (the sea)",
            -order_by => ['sense','faith','passion'],
            -limit    => '123');

$set_query = $query->get();

#print "query_thr: '$query_thr'\nset_query: '$set_query'\n\n";

die "Query set failed" unless ($query_thr eq $set_query);
 
$query_num_for = "select sparkle as clean,dog as mean " . 
                 "from book as lean,stern as obscene ".
                 "where fighting is between courage and chaos and running is null " .
                 "group by a,raging,fire,water " .
                 "having fishes in (the sea) and kitties=on_tv " .
                 "order by sense,faith,passion,for,lust,is,nowhere,bound ".
                 "limit 123,9678";
    
$get_add_query = $query->get_add(-select   => {'mean' => 'dog'},
                                 -from     => {'obscene' => 'stern'},
                                 -where    => "running is null",
                                 -order_by => ['for','lust','is','nowhere','bound'],
                                 -having   => {'kitties'=> 'on_tv'},
                                 -group_by => 'water',
                                 -limit    => ['9678']);

#print "query_num_for: '$query_num_for'\nget_add_query: '$get_add_query'\n\n";

die "Query get_add failed" unless ($query_num_for eq $get_add_query);
 
$query_num_fiv = "select sparkle as clean " . 
                 "from shoes as clean ".
                 "where fighting is between courage and chaos " .
                 "group by nothing,much " .
                 "having fishes in (the sea) " .
                 "order by logic,reason,might ".
                 "limit 123";
    
$get_set_query = $query->get_set(-from     => {'clean' => 'shoes'},
                                 -order_by => ['logic','reason','might'],
                                 -group_by => ['nothing' => 'much']);

#print "query_num_fiv: '$query_num_fiv'\nget_set_query: '$get_set_query'\n\n";

die "Query get_set failed" unless ($query_num_fiv eq $get_set_query);
 
$query_num_six = "select nothing ";
    
$query->set(-select   => 'nothing',
            -from     => '',
            -where    => '',
            -group_by => '',
            -having   => '',
            -order_by => '',
            -limit    => '');

$get_not_query = $query->get();

#print "query_num_six: '$query_num_six'\nget_not_query: '$get_not_query'\n\n";

die "Destructive query failed" unless ($query_num_six eq $get_not_query);
 
print "Everything seems fine\n";