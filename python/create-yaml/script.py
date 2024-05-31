import yaml

data = {
    'apiVersion': 'argoproj.io/v1alpha1',
    'kind': 'CronWorkflow',
    'metadata':{
        'name': 'workflow',
        'namespace': 'default'
    },
    'spec': {
        'schedule': '0 1 * * *',
        'concurrencyPolicy': 'Forbid',
        'workflowSpec': {
            'entrypoint': 'job1',
            'templates': [
                {
                    'name': 'job1',
                    'steps':[
                        {
                            'name': 'step1',
                            'template': 'submit-job-to-spark'
                        }
                    ]
                },
                {
                    'name': 'submit-job-to-spark'
                }
            ]
        }
    }

# Define the YAML file name
filename = 'output.yaml'

# Write the data to a YAML file
with open(filename, 'w') as file:
    yaml.dump(data, file, default_flow_style=False)

# Read the data back from the YAML file to verify
with open(filename, 'r') as file:
    loaded_data = yaml.safe_load(file)

print(loaded_data)
