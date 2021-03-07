import boto3
import json

ec2 = boto3.resource('ec2')

action_start = "start"
action_stop = "stop"
action_reboot = "reboot"
action_terminate = "terminate"
action_switch = "switch"

def handler(event, context):

    print('EVENT: ' + json.dumps(event))

    action = event['action']
    instances = event['instances']

    for id in instances:
        instance = ec2.Instance(id)
        state_name= instance.state["Name"]

        is_running = state_name == 'running'
        is_stopped = state_name == 'stopped'
        
        if action == action_start:
            if is_stopped:
                instance.start()
            else:
                print('ACTION_START: ' + id +' is not stopped (' + state_name + '), nothing to do')
            continue

        if action == action_stop:
            if is_running:
                instance.stop()
            else:
                print('ACTION_STOP: ' + id +' is not running (' + state_name + '), nothing to do')
            continue
        
        if action == action_reboot: 
            if is_running:
                instance.reboot()
            else:
                print('ACTION_REBOOT: ' + id +' is not running (' + state_name + '), nothing to do')
            continue

        if action == action_terminate:
            instance.terminate()
            continue
        
        if action == action_switch:
            if is_running:
                instance.stop()
                print('ACTION_SWITCH: ' + id +' to stop')
            elif is_stopped:
                instance.start()
                print('ACTION_SWITCH: ' + id +' to start')
            else:
                print('ACTION_SWITCH: ' + id +' is not running/stopped (' + state_name + '), nothing to do')
            continue

    return
