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
        <div class="container-fluid">
            <!-- Row 1: System Summary (left) | System Status (centre) | BIOS Summary (right) -->
            <div class="row" style="align-items: stretch;">
                <div class="col-4 d-flex flex-column">
                    <div class="title">System Summary</div>
                    <div class="propertyblock flex-grow-1">
                        <table class="kv-table">
                            <tr v-for="entry in ['Name', 'Id', 'SerialNumber', 'Model']" :key="entry">
                                <td class="kv-key">{{ entry }}</td>
                                <td class="kv-val">{{ resource[entry] }}</td>
                            </tr>
                            <tr><td class="kv-key">Manufacturer</td><td class="kv-val">{{ resource['Manufacturer'] }}</td></tr>
                            <tr><td class="kv-key">ProcessorModel</td><td class="kv-val">{{ resource.ProcessorSummary ? resource['ProcessorSummary']['Model'] : 'n/a' }}</td></tr>
                        </table>
                    </div>
                </div>
                <div class="col-4 d-flex flex-column">
                    <div class="title">System Status</div>
                    <div class="propertyblock flex-grow-1">
                        <table class="kv-table">
                            <tr><td class="kv-key">Health</td><td class="kv-val">{{ resource.Status ? resource.Status.Health : 'n/a' }}</td></tr>
                            <tr><td class="kv-key">PowerState</td><td class="kv-val">{{ resource['PowerState'] }}</td></tr>
                            <tr><td class="kv-key">BootOverride</td><td class="kv-val">{{ resource.Boot ? resource['Boot']['BootSourceOverrideEnabled'] : 'n/a' }}</td></tr>
                        </table>
                    </div>
                </div>
                <div class="col-4 d-flex flex-column">
                    <div class="title">BIOS Summary</div>
                    <div class="propertyblock flex-grow-1">
                        <table class="kv-table">
                            <tr><td class="kv-key">Version</td><td class="kv-val">{{ resource['BiosVersion'] }}</td></tr>
                        </table>
                    </div>
                </div>
            </div>
            <!-- Row 2: Memory Summary (col-4) | Motherboard Summary (col-4) | Actions centered (col-4) -->
            <div class="row" style="align-items: stretch;">
                <div class="col-4 d-flex flex-column">
                    <div class="title">Memory Summary</div>
                    <div class="propertyblock flex-grow-1">
                        <table class="kv-table">
                            <tr><td class="kv-key">TotalSystemMemoryGiB</td><td class="kv-val">{{ resource.MemorySummary ? resource['MemorySummary']['TotalSystemMemoryGiB'] : 'n/a' }}</td></tr>
                            <tr><td class="kv-key">MemoryMirroring</td><td class="kv-val">{{ resource.MemorySummary ? resource['MemorySummary']['MemoryMirroring'] : 'n/a' }}</td></tr>
                        </table>
                    </div>
                </div>
                <div class="col-4 d-flex flex-column">
                    <div class="title">Motherboard Summary</div>
                    <div class="propertyblock flex-grow-1">
                        <table class="kv-table">
                            <tr><td class="kv-key">Manufacturer</td><td class="kv-val">{{  }}</td></tr>
                            <tr><td class="kv-key">Model</td><td class="kv-val">{{ resource['Model'] }}</td></tr>
                            <tr><td class="kv-key">SerialNumber</td><td class="kv-val">{{  }}</td></tr>
                            <tr><td class="kv-key">Version</td><td class="kv-val">{{ }}</td></tr>
                        </table>
                    </div>
                </div>
                <div class="col-4 d-flex flex-column align-items-center">
                    <div class="title">Actions</div>
                    <div class="propertyblock w-100 text-center">
                        <div>
                            <ActionModal :service="service" 
                            :action_uri= "'/redfish/v1/Systems/' + resource.Id + '/Actions/ComputerSystem.Reset'" 
                            :action_info="action_params['reset']"
                            title="Reset System" short="Reset System"/>
                        </div>
                        <div style="margin-top: 8px;">
                            <button type="button" @click="resetToBios">Reset to BIOS</button>
                        </div>
                        <!-- <div>
                            <ActionPatchPost :service="service" 
                            :action_uri="'/redfish/v1/Systems/' + resource.Id " :action_info="action_params['one_time_boot']" :call_type="'PATCH'"
                            title="One Time Boot Override" short="One Time Boot Override"
                            msg="Are you sure you wish to reset this System?"/>
                        </div>
                        <div>
                            <ActionModal :service="service" 
                            :action_uri= "'/redfish/v1/Systems/' + resource.Id + '/Actions/ComputerSystem.Reset'" 
                            title="Modify BIOS" short="Modify BIOS"
                            msg="Are you sure you wish to reset this System?"/>
                        </div> -->
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
            if (this.resource.Boot['BootSourceOverrideTarget@Redfish.AllowableValues']) {
                this.action_params['one_time_boot']['Boot.BootSourceOverrideTarget']['value'] = this.resource.Boot['BootSourceOverrideTarget@Redfish.AllowableValues']
            }
            const resetAllowable = this.resource?.Actions?.['#ComputerSystem.Reset']?.['ResetType@Redfish.AllowableValues']
            if (resetAllowable) {
                this.action_params['reset']['ResetType']['value'] = resetAllowable
            }
        },
    },
    setup(props) {
        console.log(props.payload)
        console.log(props.keys)

        const action_params = ref({
            "reset": {
              'ResetType': {'option': 'ResetType', 'value': ['On', 'ForceOff', 'ForceRestart']},
            },
            "one_time_boot": { 
              'Boot.BootSourceOverrideEnabled':  {'option': "Boot.BootSourceOverrideEnabled", 'value': ['Disabled', 'Once', 'Continuous']},
              'Boot.BootSourceOverrideMode':  {'option': "Boot.BootSourceOverrideMode", 'value':['Legacy', 'Uefi']},
              'Boot.BootSourceOverrideTarget': {'option': 'Boot.BootSourceOverrideTarget', 'value': 
        ["None", "Pxe", "Floppy", "Cd", "Usb", "Hdd", "BiosSetup", "Utilities", "Diags", "UefiShell", "UefiTarget", "SDCard", "UefiHttp", "RemoteDrive", "UefiBootNext", "Recovery"]
            },
          }}
        )

        const title = ref('System')
        const resource = ref(props.payload['_payload'])
        const processors = ref(props.payload['_processors'])
        const memory = ref(props.payload['_memory'])
        const storage = ref(props.payload['_storage'])

        function resetToBios() {
            if (!confirm('Reset boot override to BIOS Setup (Once)?')) return;
            fetch('/system-action/reset-to-bios', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ service_name: props.service, system_id: resource.value.Id }),
            }).then(response => {
                if (response.status === 202 || response.status === 200) {
                    alert('Boot override set to BIOS Setup.\nPlease reset the system to enter BIOS.');
                } else {
                    alert([response.status, response.statusText, '\n'].join(' '));
                }
            });
        }

        return {title, resource, processors, memory, storage, action_params, resetToBios}
    }
}
</script>