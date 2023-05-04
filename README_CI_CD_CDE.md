What is CI, CD & CDE?
-

- Continuous Integration `CI`: the practice of frequently merging code changes into a shared repository, followed by an automated build and testing process to catch and resolve issues early on.

- Continuous Delivery `CD`: the practice of automatically building, testing, and deploying code changes to a staging or production environment.

- Continuous Deployment `CDE`: the practice of automatically deploying code changes directly to production without human intervention, assuming that all tests and quality checks have passed.

### What is Jenkins?

- Jenkins is a popular open-source automation tool used for continuous 
integration and continuous delivery. It provides a wide range of plugins that can be used to automate various aspects of the software development process, such as building, testing, and deploying code changes.

![jen dia 1.png](files%2Fjen%20dia%201.png)

- Local Host - represent local environment (computer)
- GitHub via SSH - We use SSH to securely connect to GitHub repository
- Jenkins via SSH - Will connect to the GitHub via SSH, allowing it to fetch code from the repository
- Jenkins uses GitHub Status API to update status of commit/pull request, can show if deployment was successful or not
- Jenkins also uses Deployment API to trigger and manage deployments
- WebHook trigger lets GitHub send notifications to Jenkins when an event happens in the repository, this can be a code push/pull, makes Jenkins perform a build or deployment process, it is like a signal for Jenkins to perform the actions needed depending on what takes place within the repository
- Master Node = Main jenkins server, Agent Node = computers, eg: EC2 instances
- Jenkins will use master node to manage and schedule tasks
- When there is lot of work, master node can share tasks with agent nodes, which perform tasks quickly by working on them simultaneously
- The link between both master and agent is like master node is distributing tasks to the agent nodes, and they will receive updates on the progress.


- Other tools that can be used for CI/CD include GitLab CI/CD, Travis CI, CircleCI, and AWS CodePipeline, among others.

### Jenkins stages:

- Source - pipeline retrives source code. checking the code and getting latest updates
- Build - source code compiled (readable, syntax free), dependencies resolved ( and artefacts generated, convert source code into deployable form eg exec files or libs
- Test - Various tests executed to ensure quality and functionality of application, eg unit tests, integration tests, and other automated tests
- Production - After tests, application is deployed to production environment, you prepare the infrastructure, by configuring app and deploying it to environment

### What is the difference between continuous delivery (CD) and Continuous Deployment (CDE)?


- The main difference between CD and CDE is that CD stops at deploying changes to a staging environment, while CDE deploys changes directly to production. 
- CD allows for human approval before deploying changes to production, while CDE assumes that all necessary tests and quality checks have been passed and deploys changes automatically.

### The goal of CI/CD is to achieve end to end automation.

Some basic preliminary steps:
-

1. Click on new item
2. Give your job a name: `mateusz-checking-zone`
3. Click on freestyle job - then ok
4. In the description section, enter the following: Building a job to check time zone of this server
5. Go to the build section
6. Click add build steps 
7. Then click execute shell
8. And then type: `date`
9. Click save
10. Click on build now
11. You will then see job under build history.
12. Click on drop down
13. Then click on console output
14. Back to project
15. Back to dashboard

To automate we need a specific environment for our app. (We need ubuntu & nginx).
If we are not sure what server we have so we need to test it:

1. Click on new items
2. Item name: `mateusz-os-check`
3. Freestyle job - `Ok`
4. Description: under build section - click `add build steps` 
5. Click `Execute shell`
6. Then type: uname -a
7. Click save
8. Click build now

If we want the two steps to run automatically one after the other:

1. Go to your first job
2. Click on `Configure`
3. Under post build actions (what happens if job successful or unsuccessful) 
4. Click `Build other projects`
5. Type name of project
6. Trigger if build is table
7. Click `Save`
8. click `Build now`

   
CI/CD - Jenkins to GitHub App deployment:
-

1. First we need to make sure that our GitHub repository (`CICD_with_Jenkins`) has 
our Sparta App folder inside (whether pushed or copied).

![repo_app.png](files%2Frepo_app.png)

2. Next we need to generate new `public key` & `private key` for Jenkins:
- to do that we can use `STEP 1` from this README : https://github.com/marix1993/test_ssh/blob/main/README.md
- change the name accordingly to the convention: `mateusz-jenkins key` & `mateusz-jenkins-key-pub`.
3. Next in GitHub repository `CICD_with_Jenkins` click `Settings` & then navigate to `Deploy keys`.

![deploy_keys.png](files%2Fdeploy_keys.png)
4. Click `Add deploy key` & by using command: `cat mateusz-jenkins-key.pub` in GitBash show your public key, copy it and paste to GitHub with proper name on top.
5. Next in GitBash `.ssh` folder make sure that ssh-agent is working: `eval 'ssh-agent -s'`
6. Next add key to registry: `ssh-add mateusz-jenkins-key`.
7. Head over to Jenkins and click `New item`

![jen_new_item.png](files%2Fjen_new_item.png)

8. On the next page, enter the name we use `mateusz-CI` similar naming conventions are allowed
9. Select `Freestyle project` and click `Ok`.

![free.png](files%2Ffree.png)
10. On the next page, do your description as you please, we do it as shown below. 
11. Select `Discard old builds`.
12. Select `Max # of builds to keep` - add number `3`.
13. Check the `Github project` to allow for the use of the app folder as discussed below.
14. On the GitHub repository also shown below, copy the `HTTPS link` of the repo and copy it into the `Jenkins project url`

![http.png](files%2Fhttp.png)

15. Scrolling down, check the box as shown below, and type `sparta ubuntu node` and click the popup, on the label expression.

![restric.png](files%2Frestric.png)

16. On `Source code management` click `Git`, and on `Repository 
URL`, we can see below on the repository we click `Code`,
then click `Ssh` and copy and paste that url in the repository URL.

![ssh.png](files%2Fssh.png)

17. You may be met with an error, if so click the `add` in `Credentials` and click `Jenkins`.
18. A pop up should appear, and the `ssh keys` we created before hand, using GitBash, navigate to `ssh folder` and do `cat <private-key>` and copy the `private key`.
19. We then click the `SSH dropdown` on `Kind` and enter the `key-name` on `Username`, so they match.
20. On `Private key` click `Enter directly` and paste your private key in the box below, and press add.

![priv.png](files%2Fpriv.png)

21. On `Branches to build`, change `master` to `main` as that is the branch we are using.
22. On `Build environment`, check the `Provide Node & npm bin/ folder to PATH` as shown below.

![provide_node.png](files%2Fprovide_node.png)

23. Scrolling down, click `Add build step` then click `Execute shell`.

![build_step.png](files%2Fbuild_step.png)

24. In execute shell enter (and save after) :
```commandline
cd app
npm install
npm test
```
25. Click `Build now` and wait for the build history to update, when the new build shows up, click the dropdown as shown below, and click `Console output`.

![build_now.png](files%2Fbuild_now.png)

26. After clicking `Console output` we can scroll down to see `Checks passed`, and we can see what it can look like for a successful test, shown below.

![success.png](files%2Fsuccess.png)

Webhook Trigger creation:
-

1. Create webhook for Jenkins/endpoint.
2. Create a Webhook in Github for repo where we have `app` code.
![webhook.png](files%2Fwebhook.png)

![webhook2.png](files%2Fwebhook2.png)
- make sure to paste Jenkins IP
- add `/github-webhook/` at the end
- change `Content type` to `application/json`
- check `Just the push event`
- and at the end click `Add Webhook`
- to make sure that our `Jenkins Job` has `GitHub hook trigger for GITScm polling` checked in `Build Triggers`.

![hook_tr.png](files%2Fhook_tr.png)

3. Test Webhook - testing status code 200.
4. Make change to Github readme and commit change.

On local machine - Jenkins
-
1. On GitBash, we navigate to our directory linked to repo.
2. `git pull` to pull changes from the GitHub changes we made earlier.
3. `git add .` then `git commit -m "xxxx"` then `git push` to push it to the GitHub.
4. Check Jenkins after pushing the new changes, and it should show you a new build being deployed as shown below.

![jen_chan.png](files%2Fjen_chan.png)

MERGE - NEW BRANCH - JENKINS
-

1. Create new job called `mateusz-CI-merge`, we do this by selecting our `old mateusz-CI` template.
2. Create `dev branch` on local host and make change to Readme.
- to create dev branch we need to navigate to our repo directory in GitBash
- use: `git branch dev`
- `git checkout dev`
3. If we need to push some changes to our `dev branch` we should use (make some changes to the Readme first):
- `git add .`
- `git commit -m "..."`
- `git push -u origin dev`

Automating:
-

Now we need to automate the whole process, plus we need 
to make sure that `dev branch` in Jenkins is going to run all the required tests
and if they all pass then our `dev branch` should merge with `main branch` through another Jenkins job.

1. First we need to change our `mateusz-CI` job so it can check the changes of our GitHub repo first on `dev branch`.
2. Go to `mateusz-CI` job.
3. In `Branches to build` change `Branch Specifier` from `*/main` to `*/dev`

![dev_change.png](files%2Fdev_change.png)
- click `Save`.
4. Next we need to create new job called `mateusz-CI-merge` (we can use our previous job/item as a reference).
5. In `General` add name, description & `Discard old
build` set to `Max# 3`
6. In `Source Code Management` copy the settings from the previous task. 
Then click on `Add` in `Additional Behaviours` and select `Merge before build`:
- name of repo: set to `origin`
- branch to merge to: set to `main`

![src_sett.png](files%2Fsrc_sett.png)

7. In Post-build Action click on Add and select Git Publisher:
- Enable Push only if build successful
- Enable Merge Results

![post_built.png](files%2Fpost_built.png)

- click `Save`
8. To test the job manually we can use `Build now`.

Trigger merge job if test is successful.
-

1. Go back to your `mateusz-CI` job configuration.
2. Scroll down to `Post-build actions` and add `Build other projects`
3. In `Projects to build` type the name of the project you want to run, for example `mateusz-CI-merge`.

![post_built_actions.png](files%2Fpost_built_actions.png)

4. Save your project.
5. Now, to test if it works, push some changes form your 
local repo and it should trigger the test first (`mateusz-CI`), and if the test 
is successful it will then merge the changes from dev branch 
to main branch (`mateusz-CI-merge`) and push the changes to your GitHub.

Creating a CICD pipeline:
-
1. Launch a new EC2 Instance.
2. Use `App AMI`, as it already has all the dependencies installed.
3. Add new security group, with ports below:

![inb_rules.png](files%2Finb_rules.png)

- HTTP port `80`
- SSH port `22`
- Custom TCP port `3000`
- so far all of them set on `My IP`

4. Launch the Instance.
5. Go to Jenkins.
6. Create a new job/item.
7. In General settings add name: `mateusz-CI-deploys`, description and set `Discard old builds` to 3.
8. In `Source code management` set to `Git`, `Repository URL` paste your `ssh link` to GitHub
repo, in `Credentials select` the jenkins key, and in `Branches` to build write `*/main`.
9. In Build Triggers select `GitHub hook trigger`
10. In `Build Environment` select `ssh agent`. There you have to add your `AWS pem file`, similar to how we add `ssh private key` for GitHub connection.
11. Write `Execute shell` script to run when connecting to EC2:



![shell_sc.png](files%2Fshell_sc.png)

Make sure to paste proper public IP of your instance.

```commandline
scp -v -r -o StrictHostKeyChecking=no app/ ubuntu@34.242.225.151:/home/ubuntu/
ssh -A -o StrictHostKeyChecking=no ubuntu@34.242.225.151 <<EOF

cd app
pm2 kill
# sudo npm install pm2 -g
nohup node app.js > /dev/null 2>&1 &
```
12. Save your job.
13. Now to make sure that whole process is going to run as in one pipeline go to your `mateusz-CI-merge` & click `Configure`.
14. Scroll down and in `Post-build Actions` find `Build other projects`.
15. Find your `mateusz-CI-deploy` job & check `Trigger only if build is stable`.
16. Click `Save`
17. Now, if you make any changes to the `app` and push code from your local repo, it should trigger all the job we written above and then it will launch an updated version of the app on the EC2 instance. 
For example, I changed the text that show up after pasting our Instance public IP:

![dream_team.png](files%2Fdream_team.png)











