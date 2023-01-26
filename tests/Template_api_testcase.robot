*** Settings ***
Library  Collections
Library  String
Library  RequestsLibrary
Library  OperatingSystem
Resource  ../resources/api/api_keywords.robot



*** Test Cases ***
Create Template
    [Documentation]  POST https://app.instawp.io/api/v2/templates
    Create Template

List Templates
    [Documentation]  GET https://app.instawp.io/api/v2/templates
    List Templates

Delete Template
    [Documentation]  DELETE https://app.instawp.io/api/v2/templates/{template_id}
    Delete Template