<!--
SPDX-FileCopyrightText: 2023-2024 DMTF
SPDX-License-Identifier: BSD-3-Clause
Copyright Notice:
Copyright 2023-2024 DMTF. All rights reserved.
License: BSD 3-Clause License. For full text see link: https://github.com/DMTF/Redfish-Trawler/blob/main/LICENSE.md
-->

<template>
  <!-- Use Vue template for a basic Table, on all collections -->
  <div class="basic">
      <!-- Use Vue template for a basic Table, on all collections -->
    <div v-if="view==='table'">
      <div class="title">Accounts
        <ActionPatchPost :service="service" :action_uri="'/redfish/v1/AccountService/Accounts'"
          :action_info="action_params['post_account']" :msg="'Add New Account'" :short="'Add new'" :call_type="'POST'"/>
      </div>
      <TableAccounts :payload="page_payload['_accounts']" @gotoaccount="elem => gotoResource(elem)"/>
      <TableRoles :payload="page_payload['_roles']" @gotorole="elem => gotoResource(elem)"/> 
      <div class="title" v-if="view==='table'">Properties
        <ActionPatchPost :service="service" :action_uri="'/redfish/v1/AccountService'"
          :action_info="action_params['patch_service']" :msg="'Modify Properties'" :short="'Modify'" :call_type="'PATCH'"/>
      </div>
      <div class="propertyblock">
          <div v-for="entry in ['ServiceEnabled', 'AuthFailureLoggingThreshold', 'MinPasswordLength',
                                'AccountLockoutDuration', 'AccountLockoutThreshold', 'AccountLockoutCounterResetAfter']" :key="entry">
              {{ entry }}: {{ page_payload['_payload'][entry] }}
          </div>
      </div>
    </div>

    <ResourceGeneric :service="service" :deleteable="true" :payload="page_payload" v-if="view==='resource'"/>
  </div>
</template>

<script>
import { ref } from 'vue';
import TableAccounts from '../Tables/Accounts.vue';
import TableRoles from '../Tables/Roles.vue';
import ActionPatchPost from '../Actions/ActionPatchPost.vue';
import ResourceGeneric from '../Resources/Resource.vue';
export default {
    name: 'PageUserManagement',
    components: {
        TableAccounts,
        TableRoles,
        ActionPatchPost,
        ResourceGeneric
    },
    props: ['service'],
    watch: { },
     setup(props) {
        // change value of a const ref with .value
        const page_payload = ref({'_payload': {}})
        const view = ref('table')
        const action_params = ref({
            "post_account": { 
              'Enabled':  {'option': "Enabled", 'value':true},
              'Locked':  {'option': "Locked", 'value':true},
              'Description': {'option': 'Description', 'value': 0},
              'UserName': {'option': 'UserName', 'value': 0},
              'Password': {'option': 'Password', 'value': 0},
              'RoleId': {'option': 'RoleId', 'value': 0}
            },
            "patch_service": {
              'ServiceEnabled':  {'option': "Service Enabled", 'value':true},
              'AuthFailureLoggingThreshold': {'option': 'AuthFailureLoggingThreshold', 'value': 0},
              'MinPasswordLength': {'option': 'MinPasswordLength', 'value': 0},
              'AccountLockoutDuration': {'option': 'AccountLockoutDuration', 'value': 0},
              'AccountLockoutThreshold': {'option': 'AccountLockoutThreshold', 'value': 0},
              'AccountLockoutCounterResetAfter': {'option': 'AccountLockoutCounterResetAfter', 'value': 0}
            }
          }
        )

        function gotoTable() {
          // TODO: move to its own shared function
          fetch('/page-view?service_name=' + props.service + '&page_name=usermanagement', {
              method: 'GET',
              headers: { 'Content-Type': 'application/json', 'login-info': 'get-from-here'}
          }).then(response => response.json())
          .then(payload => page_payload.value = payload)
          view.value = 'table' 
        }

        function gotoResource(elem) {
          fetch('' + elem + "?service_name=" + props.service, {
              method: 'GET',
              headers: { 'Content-Type': 'application/json', 'login-info': 'get-from-here'}
          }).then(response => response.json())
          .then(payload => page_payload.value = payload)
          view.value = 'resource' 
        }

        gotoTable()

        return {page_payload, view, action_params, gotoTable, gotoResource}
    }
}
</script>
