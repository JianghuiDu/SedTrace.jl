function generate_jacprototype(jac_type, substances, react_jp, cf)
    substances = leftjoin(substances, react_jp, on = :substance)

    jp_str = String[]
    push!(jp_str, "function JacType()")

    if jac_type == :banded
        push!(
            jp_str,
            "return BandedMatrix(Ones(Ngrid*nspec,Ngrid*nspec),(Lwbdwth,Upbdwth))",
        )
    elseif jac_type == :sparse_banded || jac_type == :sparse

        push!(jp_str, "rowID = Vector{Int}()")
        push!(jp_str, "colID = Vector{Int}()")
        sumspecies = String[]

        for i in eachrow(substances)
            # transport
            push!(
                jp_str,
                "append!(
       rowID,getindex($(i.substance)ID,vcat(1:Ngrid,1:(Ngrid-1),2:Ngrid)))",
            )
            push!(
                jp_str,
                "append!(
       colID,getindex($(i.substance)ID,vcat(1:Ngrid,2:Ngrid,1:(Ngrid-1))))",
            )
            if !ismissing(i.dependence)
                # reaction
                for j in split(i.dependence, ",")
                    push!(
                        jp_str,
                        "append!(
               rowID,getindex($(i.substance)ID,1:Ngrid))",
                    )
                    push!(
                        jp_str,
                        "append!(
               colID,getindex($(j)ID,1:Ngrid))",
                    )
                    if cf && i.type == "solid"
                        push!(
                            jp_str,
                            "append!(
                   rowID,getindex($(i.substance)ID,vcat(1:(Ngrid-1),2:Ngrid)))",
                        )
                        push!(
                            jp_str,
                            "append!(
                   colID,getindex($(j)ID,vcat(2:Ngrid,1:(Ngrid-1))))",
                        )
                    end
                end
            end
            if i.type == "dissolved_summed_pH" && i.substance != "H"
                push!(
                    jp_str,
                    "append!(
           rowID,getindex($(i.substance)ID,vcat(1:Ngrid,1:(Ngrid-1),2:Ngrid)))",
                )
                push!(
                    jp_str,
                    "append!(
           colID,getindex(HID,vcat(1:Ngrid,2:Ngrid,1:(Ngrid-1))))",
                )
                push!(sumspecies, i.substance)
            end
        end

        if "H" in substances.substance
            for i in sumspecies
                push!(
                    jp_str,
                    "append!(
           rowID,getindex(HID,vcat(1:Ngrid,1:(Ngrid-1),2:Ngrid)))",
                )
                push!(
                    jp_str,
                    "append!(
           colID,getindex($(i)ID,vcat(1:Ngrid,2:Ngrid,1:(Ngrid-1))))",
                )
            end
        end

        push!(
            jp_str,
            "return sparse(rowID,colID,ones(length(rowID)),Ngrid*nspec,Ngrid*nspec)",
        )
    end
    push!(jp_str, "end")
    return jp_str

end
