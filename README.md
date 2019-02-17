#  README
* [1. WHY](#1-why)
  * [1.1. SO, WHAT IS THIS ?!](#11-so,-what-is-this-)
  * [1.2. WHAT CAN IT DO FOR MY ORGANISATION](#12-what-can-it-do-for-my-organisation)
  * [1.3. ASSUMPTION AND PREREQUISITES](#13-assumption-and-prerequisites)
  * [1.4. PROPOSED CAPABILITIES](#14-proposed-capabilities)
  * [1.5. DEPLOYMENT AND INSTALLATION ASSISTANCE](#15-deployment-and-installation-assistance)
* [2. DEMO](#2-demo)
* [3. INSTALLATION AND CONFIGURATION](#3-installation-and-configuration)
* [4. DOCUMENTATION](#4-documentation)
  * [4.1. THE ENDUSER GUIDE](#41-the-enduser-guide)
  * [4.2. THE CONCEPTS DOC](#42-the-concepts-doc)
    * [4.2.1. The UserStories doc](#421-the-userstories-doc)
  * [4.3. THE REQUIREMENTS DOC](#43-the-requirements-doc)
    * [4.3.1. The DevOps Guide doc](#431-the-devops-guide-doc)
  * [4.4. THE INSTALLATIONS DOC](#44-the-installations-doc)
* [5. ACKNOWLEDGEMENTS](#5-acknowledgements)
    * [5.1. LICENSE](#51-license)




    

## 1. WHY
Why ?! Yet! Another App ?!

Because software production should be efficient, yet smooth and interesting ...

Because work should be inspiring and not overwhelming people. Because even good intentions without proper commitment, allocation and resourcing and most importantly, a mean for tracking advancement of an endeavor in open way reflecting the reality, might end-up making people less happy, when in fact a really simple solution could be applied for any bigger challenge requiring progress tracking, communication and coordination ... And tons of other reasons we all having been in project disasters know about ... Still here ?! Let's move on !


Figure: 1 
the 7 main entities of the qto app
![Figure: 1 
the 7 main entities of the qto app](https://raw.githubusercontent.com/YordanGeorgiev/issue-tracker/dev/doc/img/readme/what-is-is.png)

    

### 1.1. SO, WHAT IS THIS ?!

A generic postgres CRUDs ( s stands for search ) web based app for managing multiple databases from the same web application layer by means of simpliest possible UI and/or shell tools for xls export, Google sheets writes etc. An included example application is the "issue-tracker application", which is used to manage multiple projects' issues, including itself ;o). The full and extensive  http://ec2-34-243-97-157.eu-west-1.compute.amazonaws.com:8080/qto/view/features_doc must contain all the features and functionalities of this released version. This application is the reflection of the best practices and principles for tens of years in IT resulting into a product of the Multi-environment instance architecture and the Input-Output Controller Model architecture ( more about this in the http://ec2-34-243-97-157.eu-west-1.compute.amazonaws.com:8080/qto/view/system_guide_doc , which is in a way a reflection of the simple axiom in IT - "if there is one there will be many" ...

    

### 1.2. WHAT CAN IT DO FOR MY ORGANISATION
We have stumbled into real life problem in the ETL integrations of a big Scandinavian telco, which could have been solved even with the current version of the tool, although the versioning starts with the mighty zero … Of course next versions will provide much more scenarios in real-life, but this description applies to this current version, that is you can start using it as soon as you deploy your own instance ...

    

### 1.3. Assumption and prerequisites
Your organisation:

- has the need to constantly update comparably small ( less than 10k rows) hierarchy tables
- has secured intranet access to a Linux box
- has full trust to the persons in the org having http access for CRUD operations, as only basic auth over http exists
- has the a need to load MANY tables into a postgres db, which might be changing constantly DDL wise
- the API of having bigint id and uid as PK as well as default vals for nullable cols is acceptable
- might have the need to save technical documentation in versioned md format

    

### 1.4. Proposed capabilities
You could:

- deploy an instance of the issue-tracker, bare metal/docker install should take no more than 2h
- demo the simple search feature ( working only with name and description cols , but you could ddl hack-it)
- provide access to the non-technical person via http for CRUD operations
- provide them with initial links to grasp the "semi-sql" syntax
- quickly define LOTS of tables DDL by using the existing examples and just changing the columns
- load initial data via xls ( less than 10k rows per sheet should be ok )

    

### 1.5. Deployment and installation assistance
We could provide you with free assistance for the deployment of the first instance in your organization, even we consider the existing documentation good enough to deploy the application only by following the instructions in the http://ec2-34-243-97-157.eu-west-1.compute.amazonaws.com:8080/qto/view/installations_doc In the real IT life however the mealage always varies, hence this last "bonus offer".


    

## 2. DEMO
You can check the following http://ec2-34-243-97-157.eu-west-1.compute.amazonaws.com:8080/qto/view/enduser_guide_doc of the web app, additionally every doc bellow has it's "it-doc" link aka the "native" issue-tracker document format …

    

## 3. INSTALLATION AND CONFIGURATION
You could either try quickly to execute the instructions bellow this section or follow the installation instructions : 
 - in https://github.com/YordanGeorgiev/issue-tracker/blob/master/doc/md/installations_doc.md
 - in http://ec2-34-243-97-157.eu-west-1.compute.amazonaws.com:8080/qto/view/readme_doc

    

## 4. DOCUMENTATION
QTO IS about documentation, we do all the doc-fooding on our docs, which are aimed to be as up-to-date to the current release version as possible. Thus you get the following documentation set:

    

### 4.1. The EndUser Guide
The enduser guide contains mostly UI usage instructions:
 - https://github.com/YordanGeorgiev/issue-tracker/blob/master/doc/md/enduser_guide_doc.md
 - http://ec2-34-243-97-157.eu-west-1.compute.amazonaws.com:8080/qto/view/concepts_doc

    

### 4.2. The Concepts doc
General level concepts of the applicaton. 
 - https://github.com/YordanGeorgiev/issue-tracker/blob/master/doc/md/concepts_doc.md
 - http://ec2-34-243-97-157.eu-west-1.compute.amazonaws.com:8080/qto/view/concepts_doc

    

#### 4.2.1. The UserStories doc
Naturally contains the userstories of the app. 
- in https://github.com/YordanGeorgiev/issue-tracker/blob/master/doc/md/userstories_doc.md 

    

### 4.3. The Requirements doc
Contains the specs and requirements, which can be defined at the current stage of the development:
 - https://github.com/YordanGeorgiev/issue-tracker/blob/master/doc/md/requirements_doc.md
 - http://ec2-34-243-97-157.eu-west-1.compute.amazonaws.com:8080/qto/view/requirements_doc

    

#### 4.3.1. The DevOps Guide doc
Contains content on how to develop the application + general devops info.
- https://github.com/YordanGeorgiev/issue-tracker/blob/master/doc/md/devops_guide_doc.md
- http://ec2-34-243-97-157.eu-west-1.compute.amazonaws.com:8080/qto/view/devops_guide_doc

    

### 4.4. The installations doc
Contains the tasks and activities to perform to get a fully operational instance of the qto application:
 - https://github.com/YordanGeorgiev/issue-tracker/blob/master/doc/md/installations_doc.md
 - http://ec2-34-243-97-157.eu-west-1.compute.amazonaws.com:8080/qto/view/installations_doc

    

## 5. ACKNOWLEDGEMENTS
This project would NOT have been possible without the work of the people working on the following frameworks/languages/OS communities listed in no particular order.
Perl
Mojolicious
GNU Linux
Vue

Deep gratitudes and thanks to all those people ! This application aims to contain the best practices of our former colleagues and collaborators and co-travelers in life, which also deserve huge thanks for their support and contributions ! We tend to incorporate and re-use a lot of code snippets from stackoverflow and codepen, should you consider that you were the author of those code snippets and you deserve mentioning of the source please let us know ...

    

#### 5.1. LICENSE
All the trademarks mentioned in the documentation and in the source code belong to their owners. This application uses the Perl Artistic license, check the license.txt file or the following link : https://dev.perl.org/licenses/artistic.html

Should any trademark attribution be missing, mistaken or erroneous, please contact us as soon as possible for rectification.

    

