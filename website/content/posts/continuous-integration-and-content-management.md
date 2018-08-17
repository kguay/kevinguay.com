+++
title = "Easy static website editing using TravisCI and Forestry.io"
category = "programming"
date = "2018-08-17"
description = "Using Hugo, GitHub Pages, TravisCI, and Forestry.io to automate static website content changes"
layout = "blog"
tags = ["HTML", "TravisCI"]
type = "programming"
+++

## Overview

One drawback to static websites is ease of management. After working with static website compilers for the past few years, I have finally settled on a process that makes management a breeze.

## GitHub file structure

I have always used GitHub when developing websites, but mainly for the version control and collaboration features. Now it is the basis of my workflow:

I created a GitHub repository to store my pre-compiled website files. The repository has two folders in the root directory: website and binaries. "binaries" contains the hugo binary that is used to compile the website. "website" contains all of the pre-compiled website files (the hugo project).

### GitHub file structure

- binaries
 - hugo
- website
 - {website files}

## Travis CI

[TravisCI](https://travis-ci.org/) is a continuous integration (CI) SaaS that integrates directly with GitHub. The setup is pretty straight forward once you figure out which keys map where. The instructions below should help to clarify.

### Configuration file

TravisCI requires a `.travis.yml` file in the root directory of the project. `.travis.yml` contains a simple set of instructions on how to compile and where to deploy your website/app.

```
  # Clean and don't fail
  install:
    - rm -rf website/public || exit 0

  # Build the website
  script:
    - cd website
    - ../binaries/hugo

  # Deploy to GitHub pages
  deploy:
    provider: pages
    skip_cleanup: true
    local_dir: website/public
    github_token: $github_token
    on:
      branch: master
```

If you are using a custom domain with GitHub Pages, you should add the following line after github_token in the .travis.yml file:

```fqdn: example.com```

### Link repository
We will be using the Legacy Services Integration, since the new GitHub Apps method does not work with travis-ci.org (only with travis-ci.com which is paid).

1. Go to travis-ci.org
2. Sign in using GitHub
3. Click on your name in the top right corner
4. Click on Sync account to make sure that Travis CI has the latest version
5. Click on the tray x "switch" next to the repository that you want to automate

### API key
You will need an API token from Travis CI in order to communicate with GitHub. The retrieve your token:

1. Go to travis-ci.org
2. Click on your name in the top right corner
3. Click on "Settings"
4. Click "COPY TOKEN" (you will need this in the next step, so either paste it somewhere or leave it in your clipboard)

## Linking Travis CI and GitHub

### Add Travic CI service to GitHub

1. Navigate to the GitHub repository that you want to deploy with Travis
2. Click on settings (you will need to be an admin on the project)
3. Click on Integrations & services
4. Click the Add service button
5. Select Travis CI from the list
6. Enter your username
7. Paste the token that you copied in step 4 of the previous section (API key)
8. Enter "notify.travis-ci.org" for the Domain. This is the domain that GitHub will notify using your token when a push is triggered
9. Click Add service

### Add GitHub token to Travis CI

1. Click on your profile icon in the top right corner of GitHub
2. Click on "Settings"
3. Click on Developer settings
4. Click on Personal access tokens
5. Click "Generate new token"
6. Name the token "travis_ci"
7. Check only the public_repo box in the list
8. Copy the token and store somewhere secure. As GitHub warns, you will not be able to see it again.
9. Navigate to travis-ci.org
10. Click on your name in the top right corner
11. Click on “Settings” next to the repository that you are integrating
12. Under "Environmental Variables", enter github_token for the Name and the token that you ropied in step 8 for Value. This is the `$github_token` variable that you reference in the `.travis.yml` file

To test your configuration, add (or edit) a file, commit, and push to the repository. After a few seconds, you should see Travis pick up the push and compile the website. You can setup email alerts for failed builds.

## Forestry.io

Now that we can easily deploy our app using Travis CI, let's setup content management using the Forestry.io headless CMS. Forestry.io is much easier to set up than Travis.

1. Navigate to forestry.io and log in using your GitHub account
2. Select Hugo from the list of static site generators
3. Confirm which version you use
4. Select GitHub from the list of Git repositories
5. Select your repository
6. In the Config Path text box, enter `website/config.toml`
7. Invite collaborators (optional)
8. Click Import Site


This will bring you directly to the content manager. You can edit content, publish and unpublish pages, and even edit the menu if properly setup.

## Conclusion

Now, when you make a change on Forestry.io, it will automatically:

- Add, commit, and push the change to your GitHub repository
- Build and deploy with Travis CI

So there it is - an automated workflow for static websites that make editing via a web GUI easy enough for any non-programmer.