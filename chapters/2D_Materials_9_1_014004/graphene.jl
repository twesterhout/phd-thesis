include("src/tight_binding.jl")
include("src/coulomb_models.jl")
import DelimitedFiles.writedlm

function Figure_1()
    for theta in [0 10 20 30]
        lattice = armchair_bilayer_hexagon(10, rotate=theta)
        edges = nearest_neighbours(lattice)
        writedlm("data/Figure_1/bilayer_graphene_lattice_$theta.csv",
            transpose(stack((x.position..., x.sublattice) for x in lattice)), ",")
        writedlm("data/Figure_1/bilayer_graphene_edges_$theta.csv", transpose(stack(edges) .- 1), ",")
    end
end

function Figure_3()
    lattice = armchair_bilayer_hexagon(10, rotate=0)
    chi = h5open(io -> read(io["/χ"]), "data/Figure_3/chi_k=10_μ=1.34_θ=0.h5", "r")
    V = bilayer_graphene_coulomb_model(lattice; filename="data/Figure_3/uqr.h5")
    W = compute_screened_coulomb_interaction(_dielectric(chi, V), V)
    writedlm("data/Figure_3/fully_screened.csv", real.(W[:, center_site_index(lattice)]), ",")

    U, dR, _, _, _ = transform_to_real_space("data/Figure_3/uqr.h5", sublattices=4)
    writedlm("data/Figure_3/coulomb_cRPA.csv", sortslices([reshape(dR, :) reshape(U, :)], dims = 1), ",")

    coulomb = bilayer_graphene_coulomb_model(filename="data/Figure_3/uqr.h5")
    writedlm("data/Figure_3/image_charge_model.csv", [0:0.1:10 coulomb.(0:0.1:10)], ",")
end
