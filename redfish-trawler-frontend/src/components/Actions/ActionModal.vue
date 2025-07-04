
<!--
SPDX-FileCopyrightText: 2023-2025 DMTF
SPDX-License-Identifier: BSD-3-Clause
Copyright Notice:
Copyright 2023-2024 DMTF. All rights reserved.
License: BSD 3-Clause License. For full text see link: https://github.com/DMTF/Redfish-Trawler/blob/main/LICENSE.md
-->

<template>
    <!-- Button trigger modal -->
    <!-- TODO: replace each button with vue class?  Self check information before accepting -->
    <!-- Take advantage of Vues reactive forms -->
    <button type="button" class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#actionModal">
      {{ short }}
    </button>
    <div class="modal fade" id="actionModal" tabindex="-1" aria-labelledby="actionLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="actionLabel">{{ title }}</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            {{ msg }}
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-danger" @click="runAction" data-bs-dismiss="modal">Yes</button>
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          </div>
        </div>
      </div>
    </div>
</template>

<script>
import { ref } from 'vue';
export default {
  name: "ActionGeneric",
  props: ['service', 'title', 'short', 'msg', 'action_uri'],
  data() {
    return {}
  },
  watch: { },
  setup(props) {

    const action_info = ref({ })

    const action_parameters = ref({ })

    function runAction(event) {
      console.log('RUNNING ACTION NOW')
      fetch('http://127.0.0.1:5000' + props.action_uri + '?service_name=' + props.service, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
      }).then(response => alert([response.status, response.statusText, '\n'].join(' ')));
    }

    return { action_info, action_parameters, runAction}
  }
};
</script>
