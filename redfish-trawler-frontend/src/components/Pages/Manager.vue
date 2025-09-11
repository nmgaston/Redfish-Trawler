<!--
SPDX-FileCopyrightText: 2023-2024 DMTF
SPDX-License-Identifier: BSD-3-Clause
Copyright Notice:
Copyright 2023-2024 DMTF. All rights reserved.
License: BSD 3-Clause License. For full text see link: https://github.com/DMTF/Redfish-Trawler/blob/main/LICENSE.md
-->

<template>
  <div class="basic">
    <TableManager :service="service" :payload="page_payload['_members']" v-if="view==='table'" @goto="elem => gotoResource(elem)"/>
    <ResourceManager :service="service" :payload="page_payload" v-if="view==='resource'"/> 
  </div>
</template>

<script>
import { ref } from 'vue';
import TableManager from '../Tables/Manager.vue';
import ResourceManager from '../Resources/Manager.vue';
export default {
    name: 'PageManager',
    components: {
        TableManager,
        ResourceManager
    },
    props: ['service'],
    watch: { },
     setup(props) {
        // change value of a const ref with .value
        const page_payload = ref({})
        const view = ref('collection')

        function gotoTable() {
          // TODO: move to its own shared function
          fetch('/page-view?service_name=' + props.service + '&page_name=manager', {
              method: 'GET',
              headers: { 'Content-Type': 'application/json', 'login-info': 'get-from-here'}
          }).then(response => response.json())
          .then(payload => page_payload.value = payload)
          view.value = 'table' 
        }

        function gotoResource(elem) {
          console.log('GOTO!!!')
          console.log(elem)
          // TODO: move to its own shared function
          fetch('/page-view?service_name=' + props.service + '&page_name=manager&manager_name=' + elem, {
              method: 'GET',
              headers: { 'Content-Type': 'application/json', 'login-info': 'get-from-here'}
          }).then(response => response.json())
          .then(payload => page_payload.value = payload);
          view.value = 'resource' 
        }

        gotoTable()

        return {page_payload, view, gotoTable, gotoResource}
    }
}
</script>