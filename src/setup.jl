
# Datatype for temperature field
# TODO: use static arrays and pass nx,ny via constructor
mutable struct Field #{T<:AbstractFloat}
    # nx and ny are the dimensions of the field. The array data
    # contains also ghost layers, so it will have dimensions nx+2 x ny+2
    nx::Int64
    ny::Int64
    # Size of the grid cells
    dx::Float64
    dy::Float64
    # The temperature values in the 2D grid
    data::Matrix{Float64}
end

# outer constructor with default cell sizes
Field(nx, ny) = Field(nx, ny, 0.01, 0.01, zeros(nx+2, ny+2))

# extend deepcopy to new type
Base.deepcopy(f::Field) = Field(f.nx, f.ny, f.dx, f.dy, deepcopy(f.data))

"""
    initialize(rows::Int, cols::Int)

Initialize two temperature field with (nrows, ncols) number of 
rows and columns.
"""
function initialize(nrows = 1000, ncols = 1000)

    previous = Field(nrows, ncols)

    # generate a specific field with boundary conditions
    generate_field!(previous)
    current = Base.deepcopy(previous)

    return previous, current
end

"""
    generate_field!(field0::Field)

Generate a temperature field.  Pattern is disc with a radius
of nx / 6 in the center of the grid. Boundary conditions are 
(different) constant temperatures outside the grid.
"""
function generate_field!(field0::Field)
    # Square of the disk radius
    radius2 = (field0.nx / 6.0)^2

    for j = 1:field0.ny+2
        for i = 1:field0.nx+2
            ds2 = (i - field0.nx / 2)^2 + (j - field0.ny / 2)^2
            if ds2 < radius2 
                field0.data[i,j] = 5.0
            else
                field0.data[i,j] = 65.0
            end
        end 
    end 

    # Boundary conditions
    field0.data[:,1] .= 20.0
    field0.data[:,field0.ny+2] .= 70.0
    field0.data[1,:] .= 85.0
    field0.data[field0.nx+2,:] .= 5.0

end
