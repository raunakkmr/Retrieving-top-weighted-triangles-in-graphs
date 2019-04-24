include("./utils.jl")

using ArgParse
using DataStructures
using DelimitedFiles
using LightGraphs
using ScHoLP
using SimpleWeightedGraphs

"""Enumerate triangles."""
function compute_triangles(adj_list::SimpleWeightedGraph)
    seen = Set()
    for v in vertices(adj_list)
        neighbors_v = neighbors(adj_list, v)
        len = length(neighbors_v)
        for i in range(1, stop=len)
            for j in range(i+1, stop=len)
                u = neighbors_v[i]
                w = neighbors_v[j]
                triangle = Tuple(sort([u, v, w]))
                if in(triangle, seen)
                  continue
                end
                if has_edge(adj_list, u, w) || has_edge(adj_list, w, u)
                    push!(seen, triangle)
                end
            end
        end
    end

    return collect(seen)
end

"""Construct the graph, and compute and return the triangles."""
function construct_and_compute(n::Int64, edge_list::Array)
    adj_list = get_adj_list_higher_deg(n, edge_list)
    triangles = compute_triangles(adj_list)
    return triangles
end

function parse_commandline()
    s = ArgParseSettings()

    @add_arg_table s begin
        "--dataset", "-d"
            help = "dataset name"
            arg_type = String
            required = true
    end

    return parse_args(s)
end

function main()
    parsed_args = parse_commandline()
    dataset_name = parsed_args["dataset"]
    output_file = "../output/enumerate_triangles_exact_$dataset_name.txt"

    # Load data in the form of simplices from the ScHoLP package.
    ex = read_txt_data(dataset_name)

    n, edge_list = get_edge_list(ex, 1.0)
    time = @elapsed triangles = construct_and_compute(n, edge_list)
    writedlm(output_file, triangles)
    write(open(output_file, "a"), "Time: $time")
end

main()
