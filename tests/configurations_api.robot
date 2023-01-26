*** Settings ***
Library  Collections
Library  String
Library  RequestsLibrary
Library  OperatingSystem
Resource  ../resources/api/api_keywords.robot



*** Test Cases ***
List Configs
    [Documentation]  List Configs - https://app.instawp.io/api/v2/configurations
    List Configs
