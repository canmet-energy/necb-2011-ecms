require 'json'

File.open("./mini_index_map.json", 'wb'){|f|
      sim = JSON.parse(File.read("./simulations.json"))
      out = {}
      out["building_type"] = []
      out["cities"] = []
      out["id"] = {}
      out["datapoint"] = {}
      sim.each_with_index { |datapoint, i|
      skip = false
        datapoint['measures'].each_with_index { |measure, j|
          if measure['arguments'].has_key?('r_value')
            if (measure['arguments']['r_value'] > 500)
              skip=true
              break
            end
          end
        }
        next if skip
        out["id"]["#{datapoint['run_uuid']}"] = i
        out["building_type"] << datapoint['building_type']
        out["cities"] << datapoint['geography']['city']
        out["datapoint"]["#{datapoint['building_type']}"] = {} unless out["datapoint"].has_key?("#{datapoint['building_type']}")
        out["datapoint"]["#{datapoint['building_type']}"]["#{datapoint['geography']['city']}"] = [] unless out["datapoint"]["#{datapoint['building_type']}"].has_key?("#{datapoint['geography']['city']}")
        out["datapoint"]["#{datapoint['building_type']}"]["#{datapoint['geography']['city']}"] << "#{datapoint['run_uuid']}"
      }
      out["building_type"].uniq!
      out["cities"].uniq!
      f.write(JSON.pretty_generate(out))
    }
