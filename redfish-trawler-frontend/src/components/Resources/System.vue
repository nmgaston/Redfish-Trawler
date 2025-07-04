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
        <div class="container">
            <div class="row">
                <div class="col">
                    <div class="title">{{ title }}</div>
                    <div class="propertyblock">
                        <div v-for="entry in ['Name', 'Id', 'SerialNumber', 'SKU', 'Model']" :key="entry">
                            {{ entry }}: {{ resource[entry] }}
                        </div>
                        <div> Health: {{ resource.Status ? resource.Status.Health : 'n/a' }}</div>     
                        <div> PowerState: {{ resource['PowerState'] }}</div>     
                        <div> BootOverride: {{ resource['Boot']['BootSourceOverrideEnabled'] }}</div>     
                    </div>
                    <div class="title">Processors</div>
                    <table class="table">
                        <thead>
                            <tr>
                                <th scope="col-4">Name</th>
                                <th scope="col-4">Max Speed</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="entry in processors" :key="entry">
                                <td> {{ entry['Id'] }} ({{ entry['Name'] }})</td>
                                <td> {{ entry.MaxSpeedMHz ? entry['MaxSpeedMHz'] + 'MHz' : '-' }}  </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="col">
                    <div class="title">Memory</div>
                    <table class="table">
                        <thead>
                            <tr>
                                <th scope="col-4">Name</th>
                                <th scope="col-4">Capacity</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="entry in memory" :key="entry">
                                <td> {{ entry['Id'] }} ({{ entry['Name'] }})</td>
                                <td> {{ entry.CapacityMiB ? entry['CapacityMiB'] + 'MiB' : '-' }}  </td>
                            </tr>
                        </tbody>
                    </table>
                    <div class="title">Storage</div>
                    <table class="table">
                        <thead>
                            <tr>
                                <th scope="col-4">Name</th>
                                <th scope="col-4">Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="entry in storage" :key="entry">
                                <td> {{ entry['Id'] }} ({{ entry['Name'] }})</td>
                                <td> {{ entry['Status']['Health'] }}  </td>
                            </tr>
                        </tbody>
                    </table>
                    <div class="title">Actions</div>
                    <div class="propertyblock">
                        <div>
                            <ActionModal :service="service" 
                            :action_uri= "'/redfish/v1/System/' + resource.Id + '/System.Reset'" 
                            title="Reset System" short="Reset System"
                            msg="Are you sure you wish to reset this System?"/>
                        </div>
                        <div>
                            <ActionModal :service="service" 
                            :action_uri= "'/redfish/v1/System/' + resource.Id + '/System.Reset'" 
                            title="One Time Boot Override" short="One Time Boot Override"
                            msg="Are you sure you wish to reset this System?"/>
                        </div>
                        <div>
                            <ActionModal :service="service" 
                            :action_uri= "'/redfish/v1/System/' + resource.Id + '/System.Reset'" 
                            title="Modify BIOS" short="Modify BIOS"
                            msg="Are you sure you wish to reset this System?"/>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import { ref } from 'vue';
import ActionModal from '../Actions/ActionModal.vue';
export default {
    name: 'ResourceSystem',
    components: { ActionModal },
    props: ['service', 'payload', 'keys'],
    watch: {
        payload() {
            this.title = 'System'
            this.resource = this.payload['_payload']
            this.processors = this.payload['_processors']
            this.memory = this.payload['_memory']
            this.storage = this.payload['_storage']
        },
    },
    setup(props) {
        console.log(props.payload)
        console.log(props.keys)

        const title = ref('System')
        const resource = ref(props.payload['_payload'])
        const processors = ref(props.payload['_processors'])
        const memory = ref(props.payload['_memory'])
        const storage = ref(props.payload['_storage'])

        return {title, resource, processors, memory, storage}
    }
}
</script>