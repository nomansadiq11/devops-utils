# Multiple Jobs Github Action

## Usecase

- Completion on multiple jobs to run another job, like if you have 3 jobs, job2 depends on job1 and job3 depends on job1 and job2
- like there are some variable you need to use in job3 from job1
- you can configure your job3 like this

```yaml

job3:
    needs: [job1, job2] // here job1 and job2 will completed then this job will start
    runs-on: ['ubuntu']
    env:
        variables: ${{ needs.job1.outputs.somevariable }}

    steps:
        - name: Debug - Print
        run: |
            echo "variable value: $variables"

```
