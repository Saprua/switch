/*
Copyright 2013-present Barefoot Networks, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

/*
 * System global parameters
 */

action set_config_parameters(enable_dod) {
    /* read system config parameters and store them in metadata
     * or take appropriate action
     */
    deflect_on_drop(enable_dod);

#ifdef SFLOW_ENABLE
    /* use 31 bit random number generator and detect overflow into upper half
     * to decide to take a sample
     */
    modify_field_rng_uniform(ingress_metadata.sflow_take_sample,
                                0, 0x7FFFFFFF);
#endif
}

table switch_config_params {
    actions {
        set_config_parameters;
    }
    size : 1;
}

control process_global_params {
    /* set up global controls/parameters */
    apply(switch_config_params);
}
