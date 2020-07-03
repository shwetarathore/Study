${connection_string_node}

[sample:vars]
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
${ssh_user_string}
${ssh_private_key_path_string}

[sample]
${list_node}