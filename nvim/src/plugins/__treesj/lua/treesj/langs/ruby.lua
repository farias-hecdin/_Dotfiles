local a=require('treesj.langs.utils')return{array=a.set_preset_for_list(),hash=a.set_preset_for_list(),method_parameters=a.set_preset_for_args(),argument_list=a.set_preset_for_args(),string_array=a.set_preset_for_list({split={last_separator=false}}),body_statement=a.set_preset_for_non_bracket({join={force_insert=';',no_insert_if={a.no_insert.if_penultimate}}}),method={target_nodes={'body_statement'}},assignment={target_nodes={'array','hash'}}}
