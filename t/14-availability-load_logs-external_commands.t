#!/usr/bin/env perl

#########################

use strict;
use warnings;
use Test::More tests => 312;
use Data::Dumper;
use File::Temp qw/ tempfile tempdir /;

use_ok('Monitoring::Availability::Logs');

#########################

my $mal = Monitoring::Availability::Logs->new();
isa_ok($mal, 'Monitoring::Availability::Logs', 'create new Monitoring::Availability::Logs object');

####################################
# try logs, line by line

my @logs;
my $expected = [];
while(my $line = <DATA>) {
    chomp $line;
    if ($line eq '0') {
        push (@{$expected}, { 'time' => '1263042133', 'type' => 'EXTERNAL COMMAND' } );
    } elsif ($line eq '1') {
        push (@{$expected}, { 'time' => '1263042133', 'type' => 'EXTERNAL COMMAND', 'host_name' => '<host_name>' } );
    } elsif ($line eq '2') {
        push (@{$expected}, { 'time' => '1263042133', 'type' => 'EXTERNAL COMMAND', 'host_name' => '<host_name>', service_description => '<service_description>' } );
    } else {
        push (@logs, "[1263042133] EXTERNAL COMMAND: ".$line);
    }
}

#print Dumper($expected);

my $x = 0;
my $logs;
foreach my $line (@logs) {
    $logs .= $line;
    $mal->{'logs'} = [];
    my $rt = $mal->_store_logs_from_string($line);
    is($rt, 1, '_store_logs_from_string rc') or fail_out($x, $line, $mal);
    is_deeply($mal->{'logs'}->[0], $expected->[$x], 'reading logs from string') or fail_out($x, $line, $mal);
    $x++;
}
#
#####################################
## write logs to temp file and load it
#my($fh,$filename) = tempfile(CLEANUP => 1);
#print $fh $logs;
#close($fh);
#
#$mal->{'logs'} = [];
#my $rt = $mal->_store_logs_from_file($filename);
#is($rt, 1, '_store_logs_from_file rc');
#is_deeply($mal->{'logs'}, $expected, 'reading logs from file');
#
#####################################
## write logs to temp dir and load it
#my $dir = tempdir( CLEANUP => 1 );
#open(my $logfile, '>', $dir.'/monitoring.log') or die('cannot write to '.$dir.'/monitoring.log: '.$!);
#print $logfile $logs;
#close($logfile);
#
#$mal->{'logs'} = [];
#$rt = $mal->_store_logs_from_dir($dir);
#is($rt, 1, '_store_logs_from_dir rc');
#is_deeply($mal->{'logs'}, $expected, 'reading logs from dir');



####################################
# fail and die with debug output
sub fail_out {
    my $x    = shift;
    my $line = shift;
    my $mal  = shift;
    diag('line: '.Dumper($line));
    diag('got : '.Dumper($mal->{'logs'}->[0]));
    diag('exp : '.Dumper($expected->[$x]));
    BAIL_OUT('failed');
}


__DATA__
ACKNOWLEDGE_HOST_PROBLEM;<host_name>;<sticky>;<notify>;<persistent>;<author>;<comment>
1
ACKNOWLEDGE_SVC_PROBLEM;<host_name>;<service_description>;<sticky>;<notify>;<persistent>;<author>;<comment>
2
ADD_HOST_COMMENT;<host_name>;<persistent>;<author>;<comment>
1
ADD_SVC_COMMENT;<host_name>;<service_description>;<persistent>;<author>;<comment>
2
CHANGE_CONTACT_HOST_NOTIFICATION_TIMEPERIOD;<contact_name>;<notification_timeperiod>
0
CHANGE_CONTACT_MODATTR;<contact_name>;<value>
0
CHANGE_CONTACT_MODHATTR;<contact_name>;<value>
0
CHANGE_CONTACT_MODSATTR;<contact_name>;<value>
0
CHANGE_CONTACT_SVC_NOTIFICATION_TIMEPERIOD;<contact_name>;<notification_timeperiod>
0
CHANGE_CUSTOM_CONTACT_VAR;<contact_name>;<varname>;<varvalue>
0
CHANGE_CUSTOM_HOST_VAR;<host_name>;<varname>;<varvalue>
1
CHANGE_CUSTOM_SVC_VAR;<host_name>;<service_description>;<varname>;<varvalue>
2
CHANGE_GLOBAL_HOST_EVENT_HANDLER;<event_handler_command>
0
CHANGE_GLOBAL_SVC_EVENT_HANDLER;<event_handler_command>
0
CHANGE_HOST_CHECK_COMMAND;<host_name>;<check_command>
1
CHANGE_HOST_CHECK_TIMEPERIOD;<host_name>;<check_timeperod>
1
CHANGE_HOST_EVENT_HANDLER;<host_name>;<event_handler_command>
1
CHANGE_HOST_MODATTR;<host_name>;<value>
1
CHANGE_MAX_HOST_CHECK_ATTEMPTS;<host_name>;<check_attempts>
1
CHANGE_MAX_SVC_CHECK_ATTEMPTS;<host_name>;<service_description>;<check_attempts>
2
CHANGE_NORMAL_HOST_CHECK_INTERVAL;<host_name>;<check_interval>
1
CHANGE_NORMAL_SVC_CHECK_INTERVAL;<host_name>;<service_description>;<check_interval>
2
CHANGE_RETRY_HOST_CHECK_INTERVAL;<host_name>;<service_description>;<check_interval>
2
CHANGE_RETRY_SVC_CHECK_INTERVAL;<host_name>;<service_description>;<check_interval>
2
CHANGE_SVC_CHECK_COMMAND;<host_name>;<service_description>;<check_command>
2
CHANGE_SVC_CHECK_TIMEPERIOD;<host_name>;<service_description>;<check_timeperiod>
2
CHANGE_SVC_EVENT_HANDLER;<host_name>;<service_description>;<event_handler_command>
2
CHANGE_SVC_MODATTR;<host_name>;<service_description>;<value>
2
CHANGE_SVC_NOTIFICATION_TIMEPERIOD;<host_name>;<service_description>;<notification_timeperiod>
2
DELAY_HOST_NOTIFICATION;<host_name>;<notification_time>
1
DEL_ALL_HOST_COMMENTS;<host_name>
1
DEL_ALL_SVC_COMMENTS;<host_name>;<service_description>
2
DEL_HOST_COMMENT;<comment_id>
0
DEL_HOST_DOWNTIME;<downtime_id>
0
DEL_SVC_COMMENT;<comment_id>
0
DEL_SVC_DOWNTIME;<downtime_id>
0
DISABLE_ALL_NOTIFICATIONS_BEYOND_HOST;<host_name>
1
DISABLE_CONTACTGROUP_HOST_NOTIFICATIONS;<contactgroup_name>
0
DISABLE_CONTACTGROUP_SVC_NOTIFICATIONS;<contactgroup_name>
0
DISABLE_CONTACT_HOST_NOTIFICATIONS;<contact_name>
0
DISABLE_CONTACT_SVC_NOTIFICATIONS;<contact_name>
0
DISABLE_EVENT_HANDLERS
0
DISABLE_FAILURE_PREDICTION
0
DISABLE_FLAP_DETECTION
0
DISABLE_HOSTGROUP_HOST_CHECKS;<hostgroup_name>
0
DISABLE_HOSTGROUP_HOST_NOTIFICATIONS;<hostgroup_name>
0
DISABLE_HOSTGROUP_PASSIVE_HOST_CHECKS;<hostgroup_name>
0
DISABLE_HOSTGROUP_PASSIVE_SVC_CHECKS;<hostgroup_name>
0
DISABLE_HOSTGROUP_SVC_CHECKS;<hostgroup_name>
0
DISABLE_HOSTGROUP_SVC_NOTIFICATIONS;<hostgroup_name>
0
DISABLE_HOST_AND_CHILD_NOTIFICATIONS;<host_name>
1
DISABLE_HOST_CHECK;<host_name>
1
DISABLE_HOST_EVENT_HANDLER;<host_name>
1
DISABLE_HOST_FLAP_DETECTION;<host_name>
1
DISABLE_HOST_FRESHNESS_CHECKS
0
DISABLE_HOST_NOTIFICATIONS;<host_name>
1
DISABLE_HOST_SVC_CHECKS;<host_name>
1
DISABLE_HOST_SVC_NOTIFICATIONS;<host_name>
1
DISABLE_NOTIFICATIONS
0
DISABLE_PASSIVE_HOST_CHECKS;<host_name>
1
DISABLE_PASSIVE_SVC_CHECKS;<host_name>;<service_description>
2
DISABLE_PERFORMANCE_DATA
0
DISABLE_SERVICEGROUP_HOST_CHECKS;<servicegroup_name>
0
DISABLE_SERVICEGROUP_HOST_NOTIFICATIONS;<servicegroup_name>
0
DISABLE_SERVICEGROUP_PASSIVE_HOST_CHECKS;<servicegroup_name>
0
DISABLE_SERVICEGROUP_PASSIVE_SVC_CHECKS;<servicegroup_name>
0
DISABLE_SERVICEGROUP_SVC_CHECKS;<servicegroup_name>
0
DISABLE_SERVICEGROUP_SVC_NOTIFICATIONS;<servicegroup_name>
0
DISABLE_SERVICE_FLAP_DETECTION;<host_name>;<service_description>
2
DISABLE_SERVICE_FRESHNESS_CHECKS
0
DISABLE_SVC_CHECK;<host_name>;<service_description>
2
DISABLE_SVC_EVENT_HANDLER;<host_name>;<service_description>
2
DISABLE_SVC_FLAP_DETECTION;<host_name>;<service_description>
2
DISABLE_SVC_NOTIFICATIONS;<host_name>;<service_description>
2
ENABLE_ALL_NOTIFICATIONS_BEYOND_HOST;<host_name>
1
ENABLE_CONTACTGROUP_HOST_NOTIFICATIONS;<contactgroup_name>
0
ENABLE_CONTACTGROUP_SVC_NOTIFICATIONS;<contactgroup_name>
0
ENABLE_CONTACT_HOST_NOTIFICATIONS;<contact_name>
0
ENABLE_CONTACT_SVC_NOTIFICATIONS;<contact_name>
0
ENABLE_EVENT_HANDLERS
0
ENABLE_FAILURE_PREDICTION
0
ENABLE_FLAP_DETECTION
0
ENABLE_HOSTGROUP_HOST_CHECKS;<hostgroup_name>
0
ENABLE_HOSTGROUP_HOST_NOTIFICATIONS;<hostgroup_name>
0
ENABLE_HOSTGROUP_PASSIVE_HOST_CHECKS;<hostgroup_name>
0
ENABLE_HOSTGROUP_PASSIVE_SVC_CHECKS;<hostgroup_name>
0
ENABLE_HOSTGROUP_SVC_CHECKS;<hostgroup_name>
0
ENABLE_HOSTGROUP_SVC_NOTIFICATIONS;<hostgroup_name>
0
ENABLE_HOST_AND_CHILD_NOTIFICATIONS;<host_name>
1
ENABLE_HOST_CHECK;<host_name>
1
ENABLE_HOST_EVENT_HANDLER;<host_name>
1
ENABLE_HOST_FLAP_DETECTION;<host_name>
1
ENABLE_HOST_FRESHNESS_CHECKS
0
ENABLE_HOST_NOTIFICATIONS;<host_name>
1
ENABLE_HOST_SVC_CHECKS;<host_name>
1
ENABLE_HOST_SVC_NOTIFICATIONS;<host_name>
1
ENABLE_NOTIFICATIONS
0
ENABLE_PASSIVE_HOST_CHECKS;<host_name>
1
ENABLE_PASSIVE_SVC_CHECKS;<host_name>;<service_description>
2
ENABLE_PERFORMANCE_DATA
0
ENABLE_SERVICEGROUP_HOST_CHECKS;<servicegroup_name>
0
ENABLE_SERVICEGROUP_HOST_NOTIFICATIONS;<servicegroup_name>
0
ENABLE_SERVICEGROUP_PASSIVE_HOST_CHECKS;<servicegroup_name>
0
ENABLE_SERVICEGROUP_PASSIVE_SVC_CHECKS;<servicegroup_name>
0
ENABLE_SERVICEGROUP_SVC_CHECKS;<servicegroup_name>
0
ENABLE_SERVICEGROUP_SVC_NOTIFICATIONS;<servicegroup_name>
0
ENABLE_SERVICE_FRESHNESS_CHECKS
0
ENABLE_SVC_CHECK;<host_name>;<service_description>
2
ENABLE_SVC_EVENT_HANDLER;<host_name>;<service_description>
2
ENABLE_SVC_FLAP_DETECTION;<host_name>;<service_description>
2
ENABLE_SVC_NOTIFICATIONS;<host_name>;<service_description>
2
PROCESS_FILE;<file_name>;<delete>
0
PROCESS_HOST_CHECK_RESULT;<host_name>;<status_code>;<plugin_output>
1
PROCESS_SERVICE_CHECK_RESULT;<host_name>;<service_description>;<return_code>;<plugin_output>
2
READ_STATE_INFORMATION
0
REMOVE_HOST_ACKNOWLEDGEMENT;<host_name>
1
REMOVE_SVC_ACKNOWLEDGEMENT;<host_name>;<service_description>
2
RESTART_PROGRAM
0
SAVE_STATE_INFORMATION
0
SCHEDULE_AND_PROPAGATE_HOST_DOWNTIME;<host_name>;<start_time>;<end_time>;<fixed>;<trigger_id>;<duration>;<author>;<comment>
1
SCHEDULE_AND_PROPAGATE_TRIGGERED_HOST_DOWNTIME;<host_name>;<start_time>;<end_time>;<fixed>;<trigger_id>;<duration>;<author>;<comment>
1
SCHEDULE_FORCED_HOST_CHECK;<host_name>;<check_time>
1
SCHEDULE_FORCED_HOST_SVC_CHECKS;<host_name>;<check_time>
1
SCHEDULE_FORCED_SVC_CHECK;<host_name>;<service_description>;<check_time>
2
SCHEDULE_HOSTGROUP_HOST_DOWNTIME;<hostgroup_name>;<start_time>;<end_time>;<fixed>;<trigger_id>;<duration>;<author>;<comment>
0
SCHEDULE_HOSTGROUP_SVC_DOWNTIME;<hostgroup_name>;<start_time>;<end_time>;<fixed>;<trigger_id>;<duration>;<author>;<comment>
0
SCHEDULE_HOST_CHECK;<host_name>;<check_time>
1
SCHEDULE_HOST_DOWNTIME;<host_name>;<start_time>;<end_time>;<fixed>;<trigger_id>;<duration>;<author>;<comment>
1
SCHEDULE_HOST_SVC_CHECKS;<host_name>;<check_time>
1
SCHEDULE_HOST_SVC_DOWNTIME;<host_name>;<start_time>;<end_time>;<fixed>;<trigger_id>;<duration>;<author>;<comment>
1
SCHEDULE_SERVICEGROUP_HOST_DOWNTIME;<servicegroup_name>;<start_time>;<end_time>;<fixed>;<trigger_id>;<duration>;<author>;<comment>
0
SCHEDULE_SERVICEGROUP_SVC_DOWNTIME;<servicegroup_name>;<start_time>;<end_time>;<fixed>;<trigger_id>;<duration>;<author>;<comment>
0
SCHEDULE_SVC_CHECK;<host_name>;<service_description>;<check_time>
2
SCHEDULE_SVC_DOWNTIME;<host_name>;<service_description>;<start_time>;<end_time>;<fixed>;<trigger_id>;<duration>;<author>;<comment>
2
SEND_CUSTOM_HOST_NOTIFICATION;<host_name>;<options>;<author>;<comment>
1
SEND_CUSTOM_SVC_NOTIFICATION;<host_name>;<service_description>;<options>;<author>;<comment>
2
SET_HOST_NOTIFICATION_NUMBER;<host_name>;<notification_number>
1
SET_SVC_NOTIFICATION_NUMBER;<host_name>;<service_description>;<notification_number>
2
SHUTDOWN_PROGRAM
0
START_ACCEPTING_PASSIVE_HOST_CHECKS
0
START_ACCEPTING_PASSIVE_SVC_CHECKS
0
START_EXECUTING_HOST_CHECKS
0
START_EXECUTING_SVC_CHECKS
0
START_OBSESSING_OVER_HOST;<host_name>
1
START_OBSESSING_OVER_HOST_CHECKS
0
START_OBSESSING_OVER_SVC;<host_name>;<service_description>
2
START_OBSESSING_OVER_SVC_CHECKS
0
STOP_ACCEPTING_PASSIVE_HOST_CHECKS
0
STOP_ACCEPTING_PASSIVE_SVC_CHECKS
0
STOP_EXECUTING_HOST_CHECKS
0
STOP_EXECUTING_SVC_CHECKS
0
STOP_OBSESSING_OVER_HOST;<host_name>
1
STOP_OBSESSING_OVER_HOST_CHECKS
0
STOP_OBSESSING_OVER_SVC;<host_name>;<service_description>
2
STOP_OBSESSING_OVER_SVC_CHECKS
0
