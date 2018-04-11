# DevOps Playground

## Lamp Stack

This Docker create a LAMP environment with the following middleware:

 - PHP 7.0
 - MariaDB MySql latest engine
 - PhpMyAdmin

To configure Docker for setting up the environment you need to:

1. Add a **.env** file and adding the environment variables.
2. Add to the **database** folder a dump of the MySql database
3. run `docker-compose up --build`

**N.B** The database container will create automatically a database and a user with the settings specify in the .env file and it will import automatically the dump you added in the database folder.

## Python Pipeline

This folder contains the bitbucket-pipeline settings that allows to copy the files on the production server through git-ftp. After a push on the master/develop branch, the pipeline calls the deploy.py script which connects to the remote ftp with git-ftp and upload all the files except what specified in the **.git-ftp-ignore**

Configuration steps:

1. Add the following environment variables:
    - FTP_HOST: FTP host
    - FTP_PASS: FTP password
    - FTP_USER: FTP username
    - DEPLOY_PATH: Absolute path where the files are in the production environment.
2. upload the bitbucket-pipeline.yml file among with the python script on your git repo.

## Wordpress Stack

This Docker creates a WordPress website starting from the wp-content folder. It downloads and configure the WordPress core files directly in the Docker image (you can specify the WordPress version to download in the Dockerfile). Copy the files from the wordpress_config folder in the container (nominally the .htaccess and teh wp-config.php) and then copy all the files in the current directory in the wp-content folder on the conatiner.

Optionally, it runs the **php composer** on a custom directory.

To configure Docker for provisioning the environment you need to:

1. Add a **.env** file and adding the environment variables reported in the env.example file.
2. Add to the **database** folder a dump of the MySql database
3. Customize the **wp-config.php** and the **.htaccess** files accordingly with your needs.
3. run `docker-compose up --build`

**N.B** The database container will create automatically a database and a user with the settings specify in the .env file and it will import automatically the dump you add in the database folder.

## SSH GIT Pipeline

In this directory you can find two different bitbucket pipelines for NodeJS applications:

1. **bitbuckt-pipeline.yml**: this pipeline connects to the production/staging server through SSH and then run the `deploy.sh` script which makes a `git pull` and then restart the pm2 process manager. You need to set-up the following environment variables in the BitBucket pipeline settings:

- SSH_USER: the username wich you have access to the remote server
- HOST: the remote host
- PRIVATE_KEY: The SSH private key. This is store as environment variable after encoding it in base64

2. **bitbucket-pipeline-w-test.yml**: this pipeline run the following steps:

    1. Install the Node project dependencies
    2. Run the test suite
    3. Build the Docker container and push it on the remote Docker repository.
    4. Connect to the remote host via SSH
    5. Stop the container in the remote host by using `docker-compose`
    6. Pull the updated image
    7. Start the update container.

You need to set-up the following environment variables in the BitBucket pipeline settings:

- NODE_ENV_TEST: the node test environment variable
- DOCKER_USER: the usernmae of the remote docker repository
- DOCKER_PASSWORD: the password of the remote docker repository
- DOCKER_REPO: the url of the remote docker repository
- HOST: the remote host
- PRIVATE_KEY: The SSH private key. This is store as environment variable after encoding it in base64

## Copy Files Pipeline

In this directory you can find a BitBucket pipeline which creates a bundle of files ot be deployed and deploy them through SSH. The `deploy.sh` file does the following actions:

1. Create a folder where the files that form the deployment package will be placed (ifalready exists, it deletes it first.)
2. Search for the `.deployignore` file, that contains a list of files that don't need to copy on the remote host.
3. It iterates on each file in the current directory and if they don't match with the entry in the deployignore file, they're copied in the destination folder.
4. A tarball file is created
5. The tarball file is transferred to the remote host via SCP
6. Connect to the remote host via SSH, by using the SSH key provided
7. Extract the content from the tarball in the destination folder, with the `--overwrite` flag with overwrite the existing files.
6. The correct permissions are given to the files.


You need to set-up the following environment variables in the BitBucket pipeline settings:

- SSH_USER: the username wich you have access to the remote server
- HOST: the remote host
- PRIVATE_KEY: The SSH private key. This is store as environment variable after encoding it in base64


