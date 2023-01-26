# API-AutomationTesting-Robot-Framework

# Client Name - InstaWP (https://app.instawp.io)
# Client Project  -Instawp API Automation Testing using Robot Framework
# Project Description - Wordpress, Site and Template creation , Plungin and theam installation to created site, Deployement, Integration to Git repoitry via Instawp app, Provides Code Editor, PHP DB editor, View logs for created site, Manage domains , delete sties and template, Reserved sites.

*Note*- Select - master brnch to view code and folders

*Used Robot Framework Libraries* - 
Library  Process
Library  RequestsLibrary
Library  OperatingSystem
Library  JSONLibrary

*To Run testcases*
robot -d Result -v ENVIROMENT:QA <testcase_file_path/testcasefilename>.robot

*API Testcase covered* -
1. Create a Site from csv
2. Create a Site
3. Get List of Sites
4. Get Site Object
5. Delete a Site
6. List Teams
7. Create Template
8. List Template
9. Delete Template
10. List Configurations
11. Create site from Template - Private site

