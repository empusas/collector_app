# Setup instructions for development environment #

Follow those instructions to setup a development VM with a docker container for the application.
You will need about 6Gb of empty disk space on your system to start.
The VM disk is set to dnymically allocate more storage as requirred and may take up to 40GB if the disk is full.

## Install VirtualBox ##

Got to [VirtualBox Homepage](https://www.virtualbox.org/) and download VirtualBox for your platform if it is not already installed. Install it by following the instructions on the homepage.

At the time of writing this guide the aktual version is Version 6.1.26 r145957.

## Install Vagrant ##

Go to  [Vagrant Homepage](https://www.vagrantup.com/) and download the aktual version for your OS. Install it by following the instructions on the homepage.

Check that Vagrant is properly installed by opening a terminal session and check the version.

`# vagrant --version`

## Install GIT for your platform ##

Got to [GIT Homepage](https://git-scm.com/download/) and download GIT for your platform if it is not already installed. Install it by following the instructions on the homepage.

Check that GIT is properly installed by opening a terminal session and check the version.

`# git --version`

## Create a Workfolder ##

Create a new directoy on your workstaion for your projects or use an existing working directoy where you have sub-directies for other projects.

## Clone the Repository ##

You should have you SSH keys already installed in github, then the authentication will use the key automatically.

If you don´t have a SSH key pair, then now is the right time to create one and install the public key in  github.

Enter the work directory you created in the previous step.

Clone the Repository in this directory with GIT:

`git clone git@github.com:empusas/collector_app.git`

## Build the development VM with Vagrant ##

After the clooning of the repository you should have a new folder with all the project files. Enter the new folder.

In the new folder there should be a file with name "Vagrantfile" with no extension.

Now you just start the build with

`# vagrant up`

You can follow the commandline output while the VM is created and the requirred software and packages are installed.

As part of the setup a container will be created inside the VM that will later contain our application. Some modules require to be compiled. That might take a while, especially on the first start of the VM.

The docker container will have all the python modules from the requirements.txt file and all the ansible collections from the ansible_requirements.yml file.

## Connect to the development VM and start the application container ##

Once the installation is completed you can enter the new VM with:

`# vagrant ssh`

The login should change and you should be in the VM now.

Now test if the container is working. Change to the **collector_vm** folder and use docker.copose to start the container:

`# cd collector_vm`

`# sudo docker-compose up`

There should be a massage like this from the **execute.sh** shell scipt:
>Starting collector_vm_collector_app_1 ... done
>
>Attaching to collector_vm_collector_app_1
>
>collector_app_1 | Hello World!
>
>collector_app_1 | [WARNING]: No inventory was parsed, only implicit localhost is available
>
>collector_app_1 | [WARNING]: provided hosts list is empty, only localhost is available. Note that
>
>collector_app_1  | the implicit localhost does not match 'all'
>
>collector_app_1  |
>
>collector_app_1  | PLAY [Echo] ********************************************************************
>
>collector_app_1  |
>
>collector_app_1  | TASK [Gathering Facts] *********************************************************
>
>collector_app_1  | ok: [127.0.0.1]
>
>collector_app_1  |
>
>collector_app_1 | TASK [Print debug message] *****************************************************
>
>collector_app_1  | ok: [127.0.0.1] => {
>
>collector_app_1  |     "msg": "Hello world from ansible!"
>
>collector_app_1  | }
>
>collector_app_1  |
>
>collector_app_1  | PLAY RECAP *********************************************************************
>
>collector_app_1  | 127.0.0.1                  : ok=2    changed=0    unreachable=0    failed=0    >
>
>skipped=0    rescued=0    ignored=0   
>
>collector_app_1  |
>
>collector_app_1  | Hello World from Python!
>
>collector_vm_collector_app_1 exited with code 0



In order to execute any python modules or start ansible playbooks inside the container, edit the **execute.sh** shell scipt accrodingly. There are example for shell, ansible and python.

After all tasks have been completed, the container will stop, unless there is a loop in the code.

Exit the VM at any time with `# exit`

To suspend the VM and save the current state you can use `# vagrant supend`

With `# vagrant halt` vagrant will try to gracefully stop the VM, if that fail or the `--force` flag is specified the VM will be powered off.

From suspended or halt state the VM can be started again with `# vagrant up`.

`# vagrant destroy`will delete the VM with all content.

## Synced folders ##

The projectfolder **collector_vm** is mapped from your workstation into the VM. Every change in the VM will change your files on your workstation and vice versa. That way you don´t have top copy any files between the workstation and the VM.
That also allows you to use your favorite editor that you have already installed. I recommend using [Atom]("https://atom.io") or [Notepad++](https://notepad-plus-plus.org/), but you are free to choose.

Also [PyCharm]("https://www.jetbrains.com/de-de/pycharm/") is an option. But remember that the editor is installed on your workstation, the code runs in the docker container and does not need to build from scratch every time you change your code as the app folder is mapped. Setting up PyCharm with an existing container as interpreter is only for advanced users.

Inside the folder **collector_vm** is the folder **collector_app**  that is mapped into the docker container. Again, every change to the files will be replicated between the host and the VM, and is directly availble in the docker container.

All python scripts and asnible playbooks and local vars have to be in the **collector_app** folder to be availble in the container.

## Python modules and ansible collections ##

**DO NOT USE PIP TO INSTALL NEW PYTHON MODULES!**

**DO NOT USE ANSIBLE-GLAXY TO INSTALL NEW ANSIBLE COLLECTIONS!**

There are two requirements files. The requirements.txt contains the requirred Python modules and the ansible_requirements.yml contains the required ansilble collections and roles.

Every entry has a version range that makes sure we stay in the same major release until we properly tested our code with a later release.

Make sure you only install new Python modules and ansible collections by adding them to the requirements files. The container image needs to be rebuild with `# docker compose build` to incluse the new modules and collections.


## Docker images and disk space ##
With every new build docker will save an image that will increase the required disk space!

Check the list of docker images with `# sudo docker image ls`. The output should look like this:

>REPOSITORY                 TAG             IMAGE ID       CREATED              SIZE
>
>collector_vm_collector_app   latest          a272e701d733   About a minute ago   868MB
>
>none                     none          c3291c3755a0   8 hours ago          860MB
>
>python                     3.10.0-alpine   c9e1987b6bc6   13 days ago          45.4MB

Keep in mind that the Image ID are individual and will be different in your build!

In this example the container with name collector_vm_collector_app and ID a272e701d733 is our latest build. Do **not** delete this one, or you have to rebuild the container!

The conatiner with ID c9e1987b6bc6 is our base image that we use to build our container. When you delete this, it will be downloaded again with the next build.

All other imgaes like the one with ID c3291c3755a0 are older builds. You can also see the size is the nearly the same and the time stamp for creation gives you a hint when it was build.

You can remove old docker images that are not attached to any container with `# sudo docker image prune`

>WARNING! This will remove all dangling images.
>
>Are you sure you want to continue? [y/N] y
>
>Deleted Images:
>
>deleted: sha256:c3291c3755a09504d0387de4d15a2df217961ddc00d5fbf6e763aabf6683b09f
>
>deleted: sha256:4945d2b0d1614fd7cbb7a4f9b9e98e342fc28da0217d1d9ddf11cf1b195f5541
>
>deleted: sha256:16d48bd990cecbd78dc3b668ede2d66efeac0d9d5cd02704b13e3f58acb148c4
>
>deleted: sha256:45f8fef5c6463d08033ad22b7bb33e4714054ff222e298b952bf89f172fbd26a
>
>Total reclaimed space: 512.2MB

Check the images again with `# sudo docker image ls` and you see the old images are gone:

>REPOSITORY                 TAG             IMAGE ID       CREATED          SIZE
>
>collector_vm_fw_auto_app   latest          a272e701d733   30 minutes ago   868MB
>
>python                     3.10.0-alpine   c9e1987b6bc6   13 days ago      45.4MB
