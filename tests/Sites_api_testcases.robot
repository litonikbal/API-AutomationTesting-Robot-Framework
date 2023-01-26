*** Settings ***
Library  Collections
Library  String
Library  RequestsLibrary
Library  OperatingSystem
Resource  ../resources/api/api_keywords.robot



*** Test Cases ***
Create a Site
    [Documentation]  Create Site (From Scratch)
    Create a Site

Get List of Sites
    [Documentation]  get the list of sites
    Get List of Sites

Get Site Object
    [Documentation]  Get Site Object - GET https://app.instawp.io/api/v2/sites/{site_id}
    Get Site Object

Delete a Site
    [Documentation]  delete https://app.instawp.io/api/v2/sites/{site_id}
    Delete a Site