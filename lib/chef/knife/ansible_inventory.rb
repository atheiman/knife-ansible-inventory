class Chef::Knife::AnsibleInventory < Chef::Knife
  banner 'knife ansible inventory'

  deps do
    require 'chef/search/query'
  end

  option :group_by_attribute,
    long: '--group-by-attribute ATTRIBUTE',
    description: "Attribute to group hosts by"

  option :host_attribute,
    long: '--host-attribute ATTRIBUTE',
    description: "Attribute to identify hosts by",
    default: 'ipaddress'

  option :hostvars,
    long: '--hostvars RETURNED_KEY=ATTRIBUTE.PATH[,RETURNED_KEY=ATTRIBUTE.PATH]',
    description: "Comma-delimited mapping of returned hostvars to Chef attribute paths",
    default: 'ipaddress=ipaddress'

  option :query,
    long: '--query QUERY',
    description: 'Chef node search query'

  def validate_options
    missing = []
    %i(group_by_attribute host_attribute hostvars query).each do |opt|
      missing << opt unless config[opt]
    end
    raise ArgumentError, "Missing option(s): #{missing}" unless missing.empty?
  end

  def str_to_attr_path(str)
    str.split('.')
  end

  # limit node query results to the group_by_attribute and the hostvars
  def filter_result
    filter_result = {}
    config[:hostvars].split(',').each do |attr|
      key, value = attr.split('=')
      filter_result[key] = str_to_attr_path(value)
    end
    filter_result.merge(
      config[:group_by_attribute] => str_to_attr_path(config[:group_by_attribute]),
      config[:host_attribute] => str_to_attr_path(config[:host_attribute])
    )
  end

  # get all the nodes matching the given query
  def nodes_search
    nodes = []
    Chef::Search::Query.new.search(
      :node,
      config[:query],
      filter_result: filter_result
    ) { |n| nodes << n }
    nodes
  end

  def run
    validate_options

    nodes = nodes_search

    inventory = {}
    until nodes.empty?
      # TODO: currently this doesnt handle nodes that should exist in multiple groups
      # organize nodes into groups based on matching group_by_attribute values
      match_value = str_to_attr_path(config[:group_by_attribute]).inject(nodes.first, &:[])
      group_name = match_value.join(',')
      inventory[group_name] = { 'hosts' => [], 'vars' => {} }
      filtered_nodes = nodes.select do |n|
        n[config[:group_by_attribute]] == match_value
      end
      filtered_nodes.each do |n|
        inventory[group_name]['hosts'] << n
        nodes.delete(n)
      end
      # TODO: fill out group vars with
    end

    require 'pp'
    pp inventory
  end
end
