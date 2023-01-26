*** Settings ***
Library  Collections
Library  String
Library  RequestsLibrary
Library  OperatingSystem
Resource  ../resources/api/api_keywords.robot


*** Test Cases ***
Create a Site from csv
    Create a Site from csv


*** Keywords ***
Create a Site from csv
    run keyword and continue on failure  ..Create a Site from csv

..Create a Site from csv

    ${file_data}=  Get Binary File  resources/api/Testdata/data.csv
    ${files}=  Create Dictionary  file=${file_data}

    Setup Test Session
    &{headers}=  Create Dictionary  Authorization=${TOKEN_BEARER_${ENVIROMENT}}
    ${response}=  POST On Session  ${test_session}  ${URL_${ENVIROMENT}}/sites  headers=&{headers}  files=${files}
    log  ${response}
    Should Be Equal As Strings  ${response.status_code}  200
    Should Be Equal As Strings  ${response.reason}  OK

    log  ${response.json()}[status]
    should be equal as strings  ${response.json()}[status]  True
    should be equal as strings  ${response.json()}[message]  Site installation work in completed, Your website is ready!
    log  ${response.json()}[data][id]
    ${site_id}  set variable  ${response.json()}[data][id]
    set global variable  ${site_id}
    log  ${response.json()}[data][wp_url]
    ${site_url}  set variable  ${response.json()}[data][wp_url]
    set global variable  ${site_url}
    ${Site_username}  set variable  ${response.json()}[data][wp_username]
    set global variable  ${Site_username}
    ${Site_password}  set variable  ${response.json()}[data][wp_password]
    set global variable  ${Site_password}

    ${pool_site_status}  set variable  ${response.json()}[data][is_pool]
    should be equal as strings  ${pool_site_status}  True