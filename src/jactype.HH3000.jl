function JacType()
    return BandedMatrix(Ones(Ngrid * nspec, Ngrid * nspec), (Lwbdwth, Upbdwth))
end
