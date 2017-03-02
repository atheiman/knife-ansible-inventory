class Chef::Knife::AnsibleInventory < Chef::Knife
  banner 'knife ansible inventory'

  deps do
    require 'chef/search/query'
  end

  option :query,
    short: '-q QUERY',
    long: '--query QUERY',
    description: ''

  option :group_by_attribute,
    short: '-g ATTRIBUTE',
    long: '--group-by-attribute ATTRIBUTE',
    description: "Attribute to group hosts by (specify nested attribute with '.' delimiter: 'nested.attribute')"

  option :host_attributes,
    short: '-h KEY=ATTR[,KEY=ATTR]',
    long: '--host-attributes RETURNED_KEY=ATTRIBUTE.PATH[,RETURNED_KEY=ATTRIBUTE.PATH]',
    description: "Comma-delimited mapping of returned hostvars to Chef attribute paths (specify nested attributes with '.' delimiter: 'nested.attribute')",
    default: { ipaddress: ['ipaddress'] },
    proc: proc do |attrs|
      filter_result = {}
      attrs.split(',').each do |attr|
        key = attr.split('=').first
        value = attr.split('=').last.split('.')
        filter_result[key] = value
      end
      filter_result
    end

  def validate_options
    missing = []
    %i(query group_by_attribute host_attributes).each do |opt|
      missing << opt unless config[opt]
    end
    raise ArgumentError, "Missing option(s): #{missing}"
  end

  # adds the group by attribute to the host attributes
  def filter_result
    config[:host_attributes].merge(
      config[:group_by_attribute] => config[:group_by_attribute].split('.')
    )
  end

  def run
    validate_options

    # get all the nodes matching the given query
    nodes = []
    Chef::Search::Query.new.search(
      :node,
      config[:query],
      filter_result
    ) { |n| nodes << n }

    inventory = {}
    until nodes.empty?
      puts nodes.first.inspect
      nodes.delete(nodes.first)
    end
  end
end
