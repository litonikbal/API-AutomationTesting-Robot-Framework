*** Settings ***
Library  Collections
Library  String
Library  RequestsLibrary
Library  OperatingSystem
Resource  ../resources/api/api_keywords.robot



*** Test Cases ***
Create Site (From Template) - Private
    [Documentation]  ou can create sites from template using this API. Templates can be of two types: Private or Shared.
    ...  Private Sites
    ...  Set "is_shared": false and don't send "has_subscribed" parameter. Example:JSON
    ...  {
    ...   "template_slug": "slug",
    ...    "site_name": "mysite",
    ...    "is_reserved" : false
    ...  }
    ...  Shared Sites (a.k.a Sandbox Sites) -Example:JSON
    ...  {
    ...  "template_slug": "slug",
    ...  "is_shared": true,
    ...  "has_subscribed": true,
    ...  "email": "email@domain.com"
    ...  }
    Create Site (From Template) - Private