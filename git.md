Introduction to the Git Version Control System
==============================================

First of all you can find a lot of useful links at the [FTSRG cheat sheets wiki](https://github.com/FTSRG/cheat-sheets/wiki/Git) from visual tutorials to available git clients with GUI. Also there is a quite extensive [e-book](http://git-scm.com/book) about Git with nice images, it is recommended to check it out.

From [Wikipedia](http://en.wikipedia.org/wiki/Git_(software)):

"Git is a distributed revision control system with an emphasis on speed, data integrity, and support for distributed, non-linear workflows. As with most other distributed revision control systems, and unlike most client–server systems, every Git working directory is a full-fledged repository with complete history and full version-tracking capabilities, independent of network access or a central server. Git was initially designed and developed by Linus Torvalds for Linux kernel development in 2005, and has since become the most widely adopted version control system for software development."

EGit tutorial
-------------

[EGit](https://www.eclipse.org/egit/) is an Eclipse built-in git client. It comes with most of the standard Eclipse distributions and probably you won't need to install it.

The easiest way to use EGit is to open the Git perspective. To do so press ctrl+3 and type git.

![Opening the Git perspective](img/git/1-quickaccess-git-perspective.png)

It has all the important views for using git, namely: Git Repositories, History, Git Staging, Git Reflog. Let's focus on the Git Repositories view. You may browse your existing repositories, _create_ new one locally, _add_ an existing one, and _clone_ a remote git repository. Let's clone a simple repository created only for this tutorial.

![Clone a repository](img/git/2-clone-repo.png)

The repository and the URI for clone command can be found [here](https://github.com/n-a-sz/mdsd-git-demo).

![](img/git/3-repo-uri.png)

Also note, that you may connect to a repository with different protocols: https, ssh, git. You may read more about their pros and cons [here](http://git-scm.com/book/it/v2/Git-on-the-Server-The-Protocols).

The destination folder should be also given, the default folder in Windows is the User/<user-name>/git/<repo-name>. Let's leave it there now. In this wizard you may also import the projects to the eclipse workspace with a help of a checkbox.

![](img/git/4-location.png)

You may also import the projects by right clicking on the Project (or Package) Explorer and clicking import and either by "Existing Projects into workplace" from the repository folder or by "Projects from Git" and choosing the repository.

![](img/git/9-import-project.png)

Let's look at the Git Repositories view:

![Opening the Git perspective](img/git/5-repositories-view.png)

Here, you may found all of the repositories added to EGit and their details. For example, the local and remote branches, remotes and the working directory, which represents the folder of the repository. The working directory has a .git folder which contains the repository itself including the commits, branches and a configuration file.
Apart from the .git folder the actual version of the project(s) can be found here too. Note that the project is not in the eclipse workspace physically.

The other useful view is the History view. It has to bee initialized on a specific repository:

![Show history view](img/git/6-show-in-history.png)

Here you may see the commits (versions), their dependency and other metadatas about them such as Id, Message, Committer, etc. The files modified in the selected commit can be found at the lower right corner of the view.

![](img/git/7-history-view.png)

The Git Reflog view shows the local history of your executed git commands.

Before discussing the Staging view let's configure git with our name and email address. This is required as this data will be added to every commit. It is stored in the .gitconfig file under the home folder (Users/<user-name>/.gitconfig). EGit provides a GUI for this configuration in Window/Preferences//Team/Git/Configuration, as seen in the following screenshot:

![](img/git/8-git-user.png)

Let's change something in the Java project, for example by modifying the only class: Main.java, and commit it with the help of the Staging view. As in git it is unnecessary to commit every change, you can select the files to commit by staging them. It can be done in the Staging view by drag and drop. Write a commit message and commit. Note that the commit command is also available in the context menu of the repository and the project files.

![Git Staging view](img/git/10-staging.png)

Take a look at the History view. The new commit has appeared, the master branch has moved with the commit along with HEAD (as it is pointing to the branch itself). The origin/master branch is stayed as there were no synchronization with the "origin" remote git repository.

![History view, new commit](img/git/11-first-commit.png)

In the following we will learn how to resolve conflicts, with the _merge_ and _rebase_ commands by imitating others work with local branches. Let's create a new branch named "feature" pointing to our previous commit - right click on commit, Create Branch.

![New branch](img/git/12-branch.png)

Create a commit (on the feature branch) by modifying the Main.java class as you like. Then checkout the master branch (which is stayed on the previous commit) to set the working directory to the previous version..

![New branch](img/git/13-checkout.png)

The feature branch has disappeared, as the default configuration of the view is to show only the 'active' branch. Press the button shown on the screenshot to see the entire commit tree.

![New branch](img/git/14-show-branches.png)




