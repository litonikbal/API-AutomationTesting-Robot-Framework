*** Settings ***
Library  Collections
Library  String
Library  RequestsLibrary
Library  OperatingSystem
Resource  ../resources/api/api_keywords.robot



*** Test Cases ***
List Teams
    [Documentation]  GET https://app.instawp.io/api/v2/teams
    List Teams