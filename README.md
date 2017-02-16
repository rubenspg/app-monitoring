# Script for monitoring a DropWizard application

## Description

Simple Bash script to monitor the health check endpoints of a [DropWizard application](http://www.dropwizard.io).

## Usage

### Making the script executable

Get the script cloning this repo or downloading it in the server where the application is running
or any other Unix OS.

```
git clone git@github.com:rubenspg/app-monitoring.git
```

Make the script executable:

```
chmod +x healthcheck.sh
```

Now we are able to execute:
```
./healthcheck.sh
```

It will print this output:
```
$ ./healthcheck.sh
######################
Checking server health
######################
```

Now, the script is running and checking the health check of the application.
If something goes wrong, it will print in the console and write in a log file (~/wizard_monitor.log)

### Executing the script

***Valid Options:*** [-h | -s | -p | -r]

* -h     Prints the usage instructions
* -s     Server DNS. Default: localhost
* -p     HTTP port number of the server endpoint. Default: 8889
* -r     Restart the server if it fails [true | false]. Default: tr

Note: Press [CTRL+C] to stop the script when it is running!

### Examples

```
./healthcheck.sh -h
```

```
./healthcheck.sh -s localhost -p 8889 -r true
```

```
./healthcheck.sh -r true
```

## Troubleshooting

Check the script's log file:
```
cat ~/wizard_monitor.log
```

## Contributing

You are welcome to contribute. Just follow these steps:

### Clone or fork the repository

```
git clone git@github.com:rubenspg/webapp-java-cookbook.git
```

### Do some work

```
git checkout master
git pull origin master
git checkout -b contrib/branch_name
```

### Create a PR
```
git push -u origin contrib/branch_name
```
