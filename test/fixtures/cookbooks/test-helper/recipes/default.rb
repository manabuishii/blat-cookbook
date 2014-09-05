require 'pathname'

directory '/tmp/attributes/blat' do
  recursive true
end

file '/tmp/attributes/blat/node.json' do
  owner "root"
  mode "0400"
end

log "Dumping attributes to '/tmp/attributes/blat/node.json."

ruby_block "dump_node_attributes" do
  block do
    require 'json'

    attrs = JSON.parse("{}")

    attrs = attrs.merge(node.default_attrs) unless node.default_attrs.empty?
    attrs = attrs.merge(node.normal_attrs) unless node.normal_attrs.empty?
    attrs = attrs.merge(node.override_attrs) unless node.override_attrs.empty?

    recipe_json = "{ \"run_list\": \[ "
    recipe_json << node.run_list.expand(node.chef_environment).recipes.map! { |k| "\"#{k}\"" }.join(",")
    recipe_json << " \] }"
    attrs = attrs.merge(JSON.parse(recipe_json))

    File.open('/tmp/attributes/blat/node.json', 'w') { |file| file.write(JSON.pretty_generate(attrs)) }
  end
end
