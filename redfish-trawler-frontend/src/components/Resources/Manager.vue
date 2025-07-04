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
                        <div v-for="entry in ['Name', 'Id', 'Model']" :key="entry">
                            {{ entry }}: {{ resource[entry] }}
                        </div>
                        <div> Health: {{ resource.Status ? resource.Status.Health : 'n/a' }}</div>     
                        <div> PowerState: {{ resource['PowerState'] }}</div>     
                    </div>

                </div>
                <div class="col">
                    <div class="title">Actions</div>
                    <div class="propertyblock">
                        <div>
                            <ActionModal :service="service" 
                            :action_uri= "'/redfish/v1/Manager/' + resource.Id + '/Manager.Reset'" 
                            title="Reset Manager" short="Reset Manager"
                            msg="Are you sure you wish to reset this Manager?"/>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import { ref } from 'vue';
export default {
    name: 'ResourceManager',
    components: { },
    props: ['payload', 'keys'],
    watch: {
        payload() {
            this.title = 'Manager'
            this.resource = this.payload['_payload']

        },
    },
    setup(props) {
        console.log(props.payload)
        console.log(props.keys)

        const title = ref('Manager')
        const resource = ref(props.payload['_payload'])

        return {title, resource}
    }
}
</script>