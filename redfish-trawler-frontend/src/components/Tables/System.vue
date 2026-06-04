<!--
SPDX-FileCopyrightText: 2023-2024 DMTF
SPDX-License-Identifier: BSD-3-Clause
Copyright Notice:
Copyright 2023-2024 DMTF. All rights reserved.
License: BSD 3-Clause License. For full text see link: https://github.com/DMTF/Redfish-Trawler/blob/main/LICENSE.md
-->

<template>
<!-- Use Vue template for a basic Table, on all collections -->
    <div class="title">{{ title }} </div>
    <div class="basic">
        <table class="table">
            <thead>
                <tr>
                    <th scope="col-4">Name</th>
                    <th scope="col-4">SystemType</th>
                    <th scope="col-2">PowerState</th>
                    <th scope="col-2">Health</th>
                    <th scope="col-2">Action</th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="entry in all_elements" :key="entry">
                    <td> <a href="#" @click="$emit('goto', entry.Id)">{{ entry.Name }} ({{ entry.Id }})</a> </td>
                    <td> {{ entry.SystemType }}</td>
                    <td> {{ entry.PowerState }}</td>
                    <td> {{ entry.Status ? entry.Status.Health : 'n/a' }}</td>     
                    <td>
                        <ActionModal :service="service" 
                            :action_uri= "'/redfish/v1/Systems/' + entry.Id + '/Actions/ComputerSystem.Reset'" 
                            :action_info="reset_params"
                            title="Reset System" short="Reset"/>
                        <button type="button" style="margin-left: 6px;" @click="resetToBios(entry.Id)">Reset to BIOS</button>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</template>

<script>
import { ref } from 'vue';
import ActionModal from '../Actions/ActionModal.vue';
export default {
    name: 'TableSystem',
    props: ['service', 'payload', 'keys'],
    components: {
        ActionModal
    },
    watch: {
        payload() {
            this.all_elements = this.payload
        },
    },
    setup(props) {

        const title = ref('Collection')
        const all_elements = ref(props.payload)
        const all_keys = ref(props.keys)
        const reset_params = ref({
            'ResetType': {'option': 'ResetType', 'value': ['On', 'ForceOff', 'ForceRestart']},
        })

        function resetToBios(systemId) {
            if (!confirm('Reset boot override to BIOS Setup (Once) for ' + systemId + '?')) return;
            fetch('/system-action/reset-to-bios', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ service_name: props.service, system_id: systemId }),
            }).then(response => {
                if (response.status === 202 || response.status === 200) {
                    alert('Boot override set to BIOS Setup.\nPlease reset the system to enter BIOS.');
                } else {
                    alert([response.status, response.statusText, '\n'].join(' '));
                }
            });
        }

        return {title, all_elements, all_keys, reset_params, resetToBios}
    }
}
</script>
