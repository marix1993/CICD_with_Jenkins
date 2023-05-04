How to create a Jenkins pipeline?
-

### Step 1. Launch an EC2 instance on AWS for Jenkins Master:
1. Set name to : `mateusz-jenkins-master`
2. Choose OS: `Canonical, Ubuntu Minimal, 18.04 LTS, amd64 bionic image build on 2022-07-17`
3. Instance type: `t2.medium` (this step is important)
4. Key pair: `tech221`
5. Now create SG with ports shown below:

![instance_1.png](files%2Fv2%2Finstance_1.png)

- launch instance.
### Step 1.1 Launch an EC2 instance on AWS for Agent Node:
1. Set name to : `mateusz-CI-app-test`
2. Choose OS: `Canonical, Ubuntu Minimal, 18.04 LTS, amd64 bionic image build on 2022-07-17`
3. Instance type: `t2.micro` (this step is important)
4. Key pair: `tech221`
5. Now create SG with ports shown below:

![instance_2.png](files%2Fv2%2Finstance_2.png)

6. Also remember to install all the dependencies required to run the app (skip that step if you used AMI for previously working app)

### Step 2. How To Install Jenkins on Ubuntu 18.04:
1. Once our `mateusz-jenkins-master` instance is running `ssh` into GitBash
2. Use commands:
```
sudo apt-get update
sudo apt-get install default-jdk -y


wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
sudo apt-get install jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins

sudo ufw allow OpenSSH
sudo ufw enable

sudo cat /var/lib/jenkins/secrets/initialAdminPassword    # password for jenkins
```
3. Now if everything went well we can start setting up our jenkins
4. Paste your EC2 instance with port 8080 in my case it's `http://34.244.181.142:8080/`
5. Next the password that we need to find by using `sudo cat /var/lib/jenkins/secrets/initialAdminPassword` in GitBash

![unloc_jen.png](files%2Fv2%2Funloc_jen.png)

6. Next step is to customize Jenkins, in my case i clicked `Install suggested plugins`:

![customize_jen.png](files%2Fv2%2Fcustomize_jen.png)

7. Next we need to set up `name`, `password` etc:

![create_admin.png](files%2Fv2%2Fcreate_admin.png)

8. Next we can see our `Jenkins URL`, click `Save and finish`:

![getting_started.png](files%2Fv2%2Fgetting_started.png)

9. If everything works we should see:

![jen_1.png](files%2Fv2%2Fjen_1.png)

### Step 3. Installing all the necessary plugins:

1. To install necessary plugins go to `Dashboard` and on the left side click `Manage Jenkins`.
2. Next click `Manage plugins` and on the left side click `Available plugins`

![manage_plugins.png](files%2Fv2%2Fmanage_plugins.png)

3. Now install all the required plugins and each time click `Install without restart`.
```
Amazon EC2 Plugin
NodeJS Plugin
Office 365 Connector
SSH Agent Plugin
GitHub # if not installed already
```
4. Next step is to apply some changes to our `Global tools`.
5. Navigate do `Dashboard` then `Manage Jenkins` and click on `Global  Global tool configuration`.

![global_tool.png](files%2Fv2%2Fglobal_tool.png)

6. Scroll down to `Node JS` section and add `name`, set `version` to 16, 
and in `Global npm packages to install` paste `sudo npm install pm2 -g` and click `Save`.

![nodejs_add.png](files%2Fv2%2Fnodejs_add.png)

### Step 4. Set a new pipeline.

To create a new pipeline you can either use this link or follow next steps:
https://github.com/marix1993/CICD_with_Jenkins/blob/main/README_CI_CD_CDE.md

#### Create `mateusz-CI` job:

1. On `Dashboard` click `+ New Item`.
2. Select proper name `mateusz-CI`, click `Freestyle project` & `Save`
3. Now implement changes:
- set `Description`: Building a CI for automated testing.
- set `Discard old builds` to: 3
- set `GitHub project` with `HTTP` address of our repo : `https://github.com/marix1993/CICD_with_Jenkins.git/`
- in `Source Code Management` select `Git` and in `Repo URL` add `SSH` address of our repo: `git@github.com:marix1993/CICD_with_Jenkins.git`
- in `Credentials` click `Add`:
    - in `Kind` select `SSH Username...`
    - in `Username` enter the name of our private key 
    - click `Enter directly`, then `Add` & paste the insights of our private key
    - if there is any problem and the key doesn't want to work in our GitBash we can use: `sudo su - jenkins`, `ssh -T git@github.com` follow the steps & exit from `Jenkins` terminal back to `Ubuntu`
    - 
- in `Branch Specifier` change */main to: */dev (don't forget to set dev branch on your local machine)
- in `Build Triggers` check `GitHub hook trigger for GITScm polling`:
  - to make our `Webhook Trigger` work first we need to create one in our GitHub repo
  - in repo with our `App` click `Settings`, `Webhooks`
  - now add the new one, in `Payload URL` add Jenkins IP plus add `/github-webhook/`
  - change the `Content type` to `application/json` and click `Save`
  
![webhook.png](files%2Fv2%2Fwebhook.png)

- in `Build Environment` click `Provide Node & npm bin/ folder to PATH`
- find the previously made `Sparta-Node-JS`
- in `Execute shell` paste those commands to run the tests on the first job:
```commandline
cd app
npm install
npm test
```

#### Create `mateusz-CI-merge` job:

1. Click `New item`, add name `mateusz-CI-merge` and click `Freestyle project`
2. Now implement changes:
- set proper description: `Merging dev branch with main`
- set `Discard old builds` to: 3
- follow previous steps with in `Source Code Management`, `Git`, `Branches`
- in `Additional Behaviours`:
  - set `Name of repository` to: origin
  - `Branch to merge to` to: main
- in `Post-build Actions` find `Git Publisher` and check both: `Push Only If Build Succeeds` & `Merge Results`

![merge_publisher.png](files%2Fv2%2Fmerge_publisher.png)

- click `Save`.

#### Create `mateusz-CI-deploy` job:

1. Click `New item`, add name `mateusz-CI-deploy` and click `Freestyle project`
2. Now implement changes:
- set proper description: `Deploying the app onto the EC2 instance.`
- set `Discard old builds` to: 3
- follow previous steps with in `Source Code Management`, `Git`
- in `Branches to build` set `Branch Specifier` to: */main
- in `Build Environment` check `Provide Node & npm bin/ folder to PATH`
- next check `SSH Agent`:
  - click `Add` & `Jenkins`
  - in `Kind` click `SSH username...`
  - `Username` set to aws_key
  - check `Enter directly`
  - click `Add` & paste the text from our `tech221.pem` file (to find it in GitBash find `.ssh` file & run `cat tech221.pem` command)
  - click `Add` & in `Credentials` find newly made key
  
![ssh_agent.png](files%2Fv2%2Fssh_agent.png)

- in `Execute shell` paste:
```commandline
scp -v -r -o StrictHostKeyChecking=no app/ ubuntu@54.76.29.114:/home/ubuntu/
ssh -A -o StrictHostKeyChecking=no ubuntu@54.76.29.114 <<EOF

cd app
pm2 kill
# sudo npm install pm2 -g
nohup node app.js > /dev/null 2>&1 &
```
- make sure to paste proper `IP` (IP from our second launched instance: `mateusz-CI-app-test`)

![shell_script.png](files%2Fv2%2Fshell_script.png)

3. All the jobs are working properly.

![the_jobs.png](files%2Fv2%2Fthe_jobs.png)

### If everything went well and every Jenkins Job created is working properly separately we can create a pipeline:
1. Navigate to first job: `mateusz-CI`.
2. Click `Configure`.
3. In `Post-build Actions` choose `Build other projects`.
4. In `Projects to build` choose our merge job `mateusz-CI-merge`
5. Check `Trigger only if build is stable` & `Save`

![build_project.png](files%2Fv2%2Fbuild_project.png)

6. Follow the same steps for `mateusz-CI-merge`:
   - click `Configure`.
   - in `Post-build Actions` choose `Build other projects`.
   - in `Projects to build` choose our merge job `mateusz-CI-deploy`
   - check `Trigger only if build is stable` & `Save`

### To check if the pipeline works properly:
1. Make some changes to your local repository.
2. Push changes to `dev` branch on GitHub.
3. Paste your `mateusz-CI-app-test` IP into the browser & add `:3000`.
4. Everything works properly.

![works.png](files%2Fv2%2Fworks.png)




*** 
Sources used to help the process:

https://www.digitalocean.com/community/tutorials/how-to-install-jenkins-on-ubuntu-18-04

https://www.jenkins.io/doc/book/getting-started/

https://www.jenkins.io/doc/book/installing/linux/#debianubuntu

https://www.jenkins.io/






