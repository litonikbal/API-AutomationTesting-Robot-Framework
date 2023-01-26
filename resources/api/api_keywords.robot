*** Settings ***
Library  Process
Library  RequestsLibrary
Library  OperatingSystem
Library  JSONLibrary



*** Variables ***
${GLOBAL_SESSION}=  global_session
${URL_APP}=    https://app.instawp.io/api/v2
${TOKEN_BEARER_APP}=  Bearer k4JRwapClzVW6o5ZIHJqLYploLP3lK1b8LgMjDc8
${URL_QA}=    https://qa.instawp.io/api/v2
${TOKEN_BEARER_QA}=  Bearer MwIQ50CrFbfuJZyUY4Zf4te0cLPvDEtsvsvo7s4X
${URL_STAGE}=    https://stage.instawp.io/api/v2
${TOKEN_BEARER_STAGE}=  Bearer PF0i118ejGWg9jBb6arvpXYpD7W5qm2G5eFJhuwn
${ENVIROMENT}=  STAGE   #use APP-for prod,QA-for QA,STAGE-for Stagging profile
${CONTENT_TYPE}=  application/json
${ACCEPT}=  application/json
${CURDIR}=  resources/Testdata

*** Keywords ***

Setup Test Session
    ${test_session}=  Set Variable  test_session
    Set Test Variable  ${test_session}
    Create Session  ${test_session}  ${URL_${ENVIROMENT}}

Teardown Test Session
    Delete All Sessions


Wait Until Http Server Is Up And Running
    Create Session  wait-until-up  ${URL_${ENVIROMENT}}  max_retries=10
    Get On Session  wait-until-up  /


Create a Site
    run keyword and continue on failure  ..Create a Site

..Create a Site

    ${file_data}=  Get Binary File  ${CURDIR}\\Testdata\\sitecreation.json
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


Get List of Sites
    run keyword and continue on failure  ..Get List of Sites

..Get List of Sites
    Setup Test Session
    &{headers}=  Create Dictionary  Authorization=${TOKEN_BEARER_${ENVIROMENT}}
    log  ${headers}

    ${response} =  GET On session  ${test_session}  ${URL_${ENVIROMENT}}/sites  headers=${headers}
    Log  ${response}
    Status Should Be  200  ${response}    #Check Status as 200
    ${response_json}=   Set Variable  ${response.json()['data']}
    log  ${response_json}
    log  ${response_json}[0][url]
    ${fetched_url}  set variable  ${response_json}[0][url]


Get Site Object
    run keyword and continue on failure  ..Get Site Object

..Get Site Object
    Setup Test Session
    &{headers}=  Create Dictionary  Authorization=${TOKEN_BEARER_${ENVIROMENT}}
    log  ${headers}

    ${response} =  GET On session  ${test_session}  ${URL_${ENVIROMENT}}/sites/${site_id}  headers=${headers}
    Log  ${response}
    Status Should Be  200  ${response}    #Check Status as 200
    ${response_json}=   Set Variable  ${response.json()['data']}
    log  ${response_json}


Delete a Site
    run keyword and continue on failure  ..Delete a Site

..Delete a Site
    Setup Test Session
    &{headers}=  Create Dictionary  Authorization=${TOKEN_BEARER_${ENVIROMENT}}
    log  ${headers}

    ${response} =  DELETE On Session  ${test_session}  ${URL_${ENVIROMENT}}/sites/${site_id}  headers=${headers}
    Log  ${response}
    Status Should Be  200  ${response}    #Check Status as 200

    ${delete_message}  set variable  ${response.json()}[message]
    should be equal as strings  ${delete_message}  Site deletion work in progress.

    ${delete_status}  set variable  ${response.json()}[status]
    should be equal as strings  ${delete_status}  True


List Teams
    run keyword and continue on failure  ..List Teams

..List Teams
    Setup Test Session
    &{headers}=  Create Dictionary  Authorization=${TOKEN_BEARER_${ENVIROMENT}}
    log  ${headers}

    ${response} =  GET On Session  ${test_session}  ${URL_${ENVIROMENT}}/teams  headers=${headers}
    Log  ${response}
    Status Should Be  200  ${response}    #Check Status as 200

    ${team_messgae}  set variable  ${response.json()}[message]
    should be equal as strings  ${team_messgae}  Teams fetched successfully

    ${team_status}  set variable  ${response.json()}[status]
    should be equal as strings  ${team_status}  True

    ${team_id}  set variable  ${response.json()}[data]\[id]


Random template name
    ${temp_name} =  Generate Random String  8  [LETTERS]
    ${template_name} =  Convert To Lowercase  ${temp_name}
    set global variable  ${template_name}

Random template description
    ${temp_desp} =  Generate Random String  10  [LETTERS]
    ${template_desp} =  Convert To Lowercase  ${temp_desp}
    set global variable  ${template_desp}

Create Template
    run keyword and continue on failure  ..Create Template

..Create Template
    Random template name
    Random template description
    Create a Site

    &{data} =  Create dictionary  description=${template_desp}  instant_template=False  mark_as_public=True  name=${template_name}  site_id=${site_id}  slug=Lincoln

    &{headers}=  Create Dictionary  Authorization=${TOKEN_BEARER_${ENVIROMENT}}

    ${response}=  POST On Session  ${test_session}  ${URL_${ENVIROMENT}}/templates  headers=&{headers}  json=${data}

    log  ${response}
    Should Be Equal As Strings  ${response.status_code}  200
    Should Be Equal As Strings  ${response.reason}  OK
    log  ${response.json()}[status]
    ${message}  set variable  ${response.json()}[message]
    should be equal as strings  ${message}  Template created successfully

    ${resp_name}  set variable  ${response.json()}[data][template][name]
    should be equal as strings  ${resp_name}  ${template_name}

    ${resp_desp}  set variable  ${response.json()}[data][template][display_text]
    should be equal as strings  ${resp_desp}  ${template_desp}

    ${team_id}  set variable  ${response.json()}[data][template][team_id]
    set global variable  ${team_id}


List Templates
    run keyword and continue on failure  ..List Templates

..List Templates
    Setup Test Session
    &{headers}=  Create Dictionary  Authorization=${TOKEN_BEARER_${ENVIROMENT}}
    log  ${headers}

    ${response} =  GET On Session  ${test_session}  ${URL_${ENVIROMENT}}/templates  headers=${headers}
    Log  ${response}
    Status Should Be  200  ${response}    #Check Status as 200

    ${message}  set variable  ${response.json()}[message]
    should be equal as strings  ${message}  Templates Fetched Successfully

    ${template_id}  set variable  ${response.json()}[data][0][id]
    set global variable  ${template_id}


Delete Template
    run keyword and continue on failure  ..Delete Template

..Delete Template
    Setup Test Session
    &{headers}=  Create Dictionary  Authorization=${TOKEN_BEARER_${ENVIROMENT}}
    log  ${headers}

    ${response} =  DELETE On Session  ${test_session}  ${URL_${ENVIROMENT}}/templates/${template_id}  headers=${headers}
    Log  ${response}
    Status Should Be  200  ${response}    #Check Status as 200

    ${delete_message}  set variable  ${response.json()}[message]
    #should be equal as strings  ${delete_message}  Site deletion work in progress.

    ${delete_status}  set variable  ${response.json()}[status]
    should be equal as strings  ${delete_status}  True


List Configs
    run keyword and continue on failure  ..List Configs

..List Configs
    Setup Test Session
    &{headers}=  Create Dictionary  Authorization=${TOKEN_BEARER_${ENVIROMENT}}
    log  ${headers}

    ${response} =  GET On Session  ${test_session}  ${URL_${ENVIROMENT}}/configurations  headers=${headers}
    Log  ${response}
    Status Should Be  200  ${response}


Create Site (From Template) - Private
    run keyword and continue on failure  ..Create Site (From Template) - Private

..Create Site (From Template) - Private
    create template
    &{headers}=  Create Dictionary  Authorization=${TOKEN_BEARER_${ENVIROMENT}}
    log  ${headers}

    &{data} =  Create dictionary  template_slug=${template_name}  site_name=mysite  is_reserved=false
    ${response} =  POST On Session  ${test_session}  ${URL_${ENVIROMENT}}/sites/template  headers=${headers}  json=${data}
    log  ${response}

    status should be  200
    should be equal as strings  ${response.reason}  OK

